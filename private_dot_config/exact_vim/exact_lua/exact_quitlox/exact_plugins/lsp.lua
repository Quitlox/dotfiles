import("mason", function(mason)
	mason.setup()
end)
import("mason-lspconfig", function(module)
	module.setup({
		automatic_installation = true,
	})
end)

----------------------------------------
-- General Configuration
----------------------------------------

-- Mappings.
local opts = { noremap = true, silent = true }
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

local function key_map(bufnr)
	local bufopts = { silent = true, noremap = true, buffer = bufnr }

	import("which-key", function(wk)
		wk.register({
			["<leader>"] = {
				h = {
					name = "Hover",
					d = { "<cmd>Lspsaga preview_definition<cr>", "Definition" },
					e = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Error" },
				},
			},
			g = {
				name = "go",
				D = { vim.lsp.buf.declaration, "Declaration" },
				d = { vim.lsp.buf.definition, "Definition" },
				i = { vim.lsp.buf.implementation, "Implementation" },
				s = {
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({ ignore_symbols = { "variable" } })
					end,
					"Signature",
				},
				t = { vim.lsp.buf.type_definition, "type Definition" },
				r = { "<cmd>Lspsaga lsp_finder<cr>", "References" },
				h = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
				f = { vim.lsp.buf.formatting, "Format" },
				a = { "<cmd>Lspsaga code_action<cr>", "Action" },
			},
		}, bufopts)
	end)

	vim.keymap.set("x", "ga", ":<c-u>Lspsaga range_code_action<cr>", bufopts)
	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help)

	vim.keymap.set("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", bufopts)
	vim.keymap.set("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", bufopts)
end

----------------------------------------
-- LSP User Interface
----------------------------------------

import("lspsaga", function(lspsaga)
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
end)

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
	key_map(bufnr)

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

local null_ls = require("null-ls")

null_ls.setup({
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
	capabilities = capabilities,
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
