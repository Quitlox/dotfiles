-- Configure Mason
-- Includes automatic setup of Debuggers (with DAP) and Formatters/Linters (with NullLs)

import({ "mason", "mason-lspconfig", "mason-nvim-dap", "mason-null-ls" }, function(modules)
	modules.mason.setup({
		ui = {
			border = "single",
		},
	})
	modules["mason-lspconfig"].setup({
		automatic_installation = false,
	})
	modules["mason-nvim-dap"].setup({
		automatic_setup = true,
	})
	modules["mason-nvim-dap"].setup_handlers()
	modules["mason-null-ls"].setup({
		ensure_installed = nil,
		automatic_installation = true,
		automatic_setup = true,
	})
end)

-- Developer support for Neovim configuration and Neovim plugin development
-- Needs to be loaded before lspconfig
import("neodev", function(module)
	module.setup({})
end)

----------------------------------------
-- Keybindings
----------------------------------------

-- Mappings
-- Add [e and ]e for navigating to Error Diagnostics
-- Add [d and ]d for navigating to any Diagnostics
import("which-key", function(wk)
	wk.register({
		["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev Diagnostic" },
		["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Prev Diagnostic" },
		["[e"] = {
			function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end,
			"Prev Error",
		},
		["]e"] = {
			function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
			end,
			"Prev Error",
		},
	})
end)

-- Custom format function to support disabling servers
local lsp_format = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			if client.name == "sumneko_lua" then
				return false
			end
			return true
		end,
		bufnr = bufnr,
	})
end

local function key_map(bufnr)
	local bufopts = { silent = true, noremap = true, buffer = bufnr }

	import("which-key", function(wk)
		wk.register({
			-- ["<leader>"] = {
			-- 	h = {
			-- 		name = "Hover",
			-- 		d = { "<cmd>Lspsaga preview_definition<cr>", "Definition" },
			-- 		e = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Error" },
			-- 	},
			-- },
			g = {
				name = "Go",
				D = { vim.lsp.buf.declaration, "Go Declaration" },
				d = { vim.lsp.buf.definition, "Go Definition" },
				i = { vim.lsp.buf.implementation, "Go Implementation" },
				s = {
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({ ignore_symbols = { "variable" } })
					end,
					"Symbols",
				},
				t = { vim.lsp.buf.type_definition, "type Definition" },
				R = { vim.lsp.buf.rename, "Go Rename" },
				r = { "<cmd>Lspsaga lsp_finder<cr>", "Go References" },
				h = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
				f = { lsp_format, "Format" },
				a = { "<cmd>Lspsaga code_action<cr>", "Action" },
			},
				K = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
		}, bufopts)
	end)

	vim.keymap.set("x", "ga", ":<c-u>Lspsaga range_code_action<cr>", bufopts)
	vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help)

	-- vim.keymap.set("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", bufopts)
	-- vim.keymap.set("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", bufopts)
end

----------------------------------------
-- LSPSaga: Winbar
----------------------------------------

-- local events = { "BufEnter", "BufWinEnter", "CursorMoved" }
--
-- vim.api.nvim_create_autocmd(events, {
-- 	pattern = "*",
-- 	callback = function()
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "LspsagaUpdateSymbol",
-- 	callback = function()
-- 	end,
-- })
--
----------------------------------------
-- LSP User Interface
----------------------------------------

import("lspsaga", function(lspsaga)
	lspsaga.init_lsp_saga({
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
		symbol_in_winbar = {
            in_custom=true,
			-- enable = true,
            -- show_file=true,
		},
	})
end)

----------------------------------------
-- General Server Settings (e.g. Keybindings)
----------------------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Cursor Highlight
	require("illuminate").on_attach(client)

	-- Default Mappings
	key_map(bufnr)

	-- TODO: What this?
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

	-- Disable default inline diagnostics
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		-- Disable virtual_text
		virtual_text = false,
	})
end

-- Completion Capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

----------------------------------------
-- Null-LS (Code Actions)
----------------------------------------

local null_ls = require("null-ls")

null_ls.setup({
	should_attach = function(bufnr)
		return vim.bo.filetype ~= "cpp"
	end,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "html", "css", "yaml", "markdown" },
		}),
		-- Python
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		-- Rust
		null_ls.builtins.formatting.trim_newlines.with({
			filetypes = { "lua", "python" }, -- use rustfmt
		}),
		null_ls.builtins.formatting.trim_whitespace.with({
			filetypes = { "lua", "python" }, -- use rustfmt
		}),
		-- Json
		null_ls.builtins.diagnostics.jsonlint,
		-- LaTeX
		null_ls.builtins.diagnostics.chktex.with({
			extra_args = { "-n8", "-n1" },
		}),
		null_ls.builtins.code_actions.proselint,
		-- Git
		null_ls.builtins.code_actions.gitsigns,
	},
})

----------------------------------------
-- Short Configs
----------------------------------------

-- Python
require("lspconfig").pyright.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		-- NOT SUPPORTED require("virtualtypes").on_attach(client, bufnr)
	end,
})

-- Vim
require("lspconfig").vimls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- LaTeX
require("lspconfig").texlab.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Bash
require("lspconfig").bashls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- JSON
import({ "schemastore", "lspconfig" }, function(modules)
	local schemastore = modules.schemastore
	local lspconfig = modules.lspconfig

	lspconfig.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	})
end)

-- Docker
require("lspconfig").dockerls.setup({

	capabilities = capabilities,
	on_attach = on_attach,
})

-- C Family
local clang_capabilities = vim.lsp.protocol.make_client_capabilities()
-- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
clang_capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({
	capabilities = clang_capabilities,
	on_attach = on_attach,
})

----------------------------------------
-- Config: Lua
----------------------------------------

local lua_lsp_config = {
	capabilities = capabilities,
	on_attach = on_attach,
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
}

require("lspconfig").sumneko_lua.setup(lua_lsp_config)

----------------------------------------
-- Config: Rust
----------------------------------------

-- The rust language server is configured by the rust-tools plugin,
-- instead of manually via lspconfig
import("rust-tools", function(rt)
	rt.setup({
		server = {
			opts = {
				tools = {
					hover_actions = { auto_focus = true },
				},
			},
			on_attach = function(_, bufnr)
				key_map(bufnr)

				-- Overwrite Join Keys keybinding
				vim.keymap.set("n", "J", rt.join_lines.join_lines, { noremap = true, buffer = bufnr })

				-- Hover actions
				vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { noremap = true, buffer = bufnr })
				-- Code action groups
				vim.keymap.set("n", "ga", rt.code_action_group.code_action_group, { noremap = true, buffer = bufnr })
			end,
		},
	})
end)
