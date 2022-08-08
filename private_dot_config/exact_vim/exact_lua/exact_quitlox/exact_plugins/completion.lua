---@diagnostic disable: need-check-nil

vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

-- Used by <Tab> key
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

-- Setup completion
cmp.setup({
	enabled = disable_inside_comment,
	formatting = {
		format = vscode_format,
	},
	snippet = {
		-- Set the Snippet Eniging
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
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
			elseif has_words_before() then
				cmp.complete()
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
		["<C-e>"] = cmp.mapping.abort(),
		["<cr>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "spell" },
	}, {
		{ name = "buffer" },
	}),
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
		{ name = "cmdline", max_item_count = 15 },
	}),
})
