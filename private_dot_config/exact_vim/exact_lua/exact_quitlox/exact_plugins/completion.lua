---@diagnostic disable: need-check-nil

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_lspkind, lspkind = pcall(require, 'lspkind')
local ok_luasnip, luasnip = pcall(require, 'luasnip')
if not (ok_cmp and ok_lspkind and ok_luasnip) then
    return
end

vim.o.completeopt = "menu,menuone,noselect"

-- Disable completion when typing comments
local disable_inside_comment = function()
	local context = require("cmp.config.context")
	-- keep command mode completion enabled when cursor is in a comment
	if vim.api.nvim_get_mode().mode == "c" then
		return true
	else
		return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
	end
end

-- VSCode-like completion formatting
local vscode_format = lspkind.cmp_format({
	mode = "symbol",
	preset = "codicons",
	before = function(entry, vim_item)
		-- vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
		return vim_item
	end,
	-- Add visual names for the sources
	menu = {
		buffer = "[Buffer]",
		nvim_lsp = "[LSP]",
		luasnip = "[LuaSnip]",
		nvim_lua = "[Lua]",
		latex_symbols = "[Latex]",
	},
})

-- Hover Documentation
local function show_documentation()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" then
        -- Plugin: Saecki/crates.nvim
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end
vim.keymap.set("n", "K", show_documentation, { noremap = true, silent = true })

-- Setup completion
cmp.setup({
	enabled = disable_inside_comment,
	formatting = {
		format = vscode_format,
	},
	snippet = {
		-- Set the Snippet Engine
		expand = function(args)
			import("luasnip", function(ls)
				ls.lsp_expand(args.body)
			end)
		end,
	},
	-- Enable border around completion
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			-- Note: This is in the default config, but breaks <tab> when positioned at the end of a word in insert mode
			-- elseif has_words_before() then
			-- 	cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("python", {
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			require("cmp-under-comparator").under,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Command Line Completion
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline_history", max_item_count = 15 },
		{ name = "path", max_item_count = 15 },
	}, {
		{ name = "cmdline", max_item_count = 10 },
	}),
})
