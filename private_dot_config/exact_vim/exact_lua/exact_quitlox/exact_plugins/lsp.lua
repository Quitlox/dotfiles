require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})

local wk = require("which-key")

----------------------------------------
-- General Configuration
----------------------------------------

-- Mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
vim.keymap.set("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)
vim.keymap.set("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)

----------------------------------------
-- Keybindings
----------------------------------------

local function key_map(bufopts)
	wk.register({
		["<leader>"] = { h = {
			d = { "<cmd>Lspsaga preview_definition" },
		} },
		g = {
			name = "go",
			D = { vim.lsp.buf.declaration, "declaration" },
			d = { vim.lsp.buf.definition, "definition" },
			i = { vim.lsp.buf.implementation, "implementation" },
			s = { vim.lsp.buf.signature_help, "signature" },
			t = { vim.lsp.buf.type_definition, "type definition" },
			r = { "<cmd>Lspsaga lsp_finder<cr>", "references" },
			e = { "<cmd>Lspsaga show_line_diagnostics<cr>" },
			h = { "<cmd>Lspsaga hover_doc<cr>" },
			f = { vim.lsp.buf.formatting, "format" },
			a = { "<cmd>Lspsaga code_action<cr>", "action" },
		},
	}, bufopts)

	vim.keymap.set("x", "ga", ":<c-u>Lspsaga range_code_action<cr>", bufopts)
	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)

	vim.keymap.set("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", bufopts)
	vim.keymap.set("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", bufopts)
end

----------------------------------------
-- LSP User Interface
----------------------------------------

local lspsaga = require("lspsaga")
lspsaga.setup({
	max_preview_lines = 20,
	finder_action_keys = {
		open = "<cr>",
		vsplit = "b",
		split = "v",
		quit = "<esc>",
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},
	code_action_keys = {
		quit = "<esc>",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<esc>",
		exec = "<CR>",
	},
	rename_prompt_prefix = "➤",
	rename_output_qflist = {
		enable = false,
		auto_open_qflist = false,
	},
})

----------------------------------------
-- General Server Settings (e.g. Keybindings)
----------------------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Server specific workarounds
	if client.name == "sumneko_lua" then
		-- We ignore the built-in formatter of sumneko_lua, and use stylua provided via null-ls
		client.resolved_capabilities.document_formatting = false
	end

	-- Cursor Highlight
	require("illuminate").on_attach(client)

	-- Default Mappings
	local bufopts = { silent = true, noremap = true }
	key_map(bufopts)

	-- TODO: What this?
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

-- Completion Capabilities
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

----------------------------------------
-- Null-LS (Code Actions)
----------------------------------------

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

null_ls.setup({
	-- you can reuse a shared lspconfig on_attach callback here
	-- on_attach = function(client, bufnr)
	-- 	if client.supports_method("textDocument/formatting") then
	-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			group = augroup,
	-- 			buffer = bufnr,
	-- 			callback = function()
	-- 				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
	-- 				vim.lsp.buf.formatting_sync()
	-- 			end,
	-- 		})
	-- 	end
	-- end,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "html", "css", "yaml", "markdown", "json" },
		}),
		-- Python
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		-- Rust
		null_ls.builtins.formatting.trim_newlines.with({
			disabled_filetypes = { "rust" }, -- use rustfmt
		}),
		null_ls.builtins.formatting.trim_whitespace.with({
			disabled_filetypes = { "rust" }, -- use rustfmt
		}),
	},
})

----------------------------------------
-- Short Configs
----------------------------------------

-- Python
require("lspconfig")["pyright"].setup({
	-- capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		-- NOT SUPPORTED require("virtualtypes").on_attach(client, bufnr)
	end,
})

-- Vim
require("lspconfig")["vimls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

----------------------------------------
-- Config: Lua
----------------------------------------

require("lspconfig").sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
	end,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
