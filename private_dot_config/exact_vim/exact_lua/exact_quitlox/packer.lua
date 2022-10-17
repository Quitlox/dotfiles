vim.o.termguicolors = true

----------------------------------------
-- Packer Bootstrapping
----------------------------------------
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	----------------------------------------
	-- Dependencies
	----------------------------------------

	-- Telescope / Plenary
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })
	-- Devicons
	use({ "kyazdani42/nvim-web-devicons" })

	-- Import: Makes sure requires don't break the entire fucking config
	use("miversen33/import.nvim")
	-- Pretty Print: Nice for debugging
	use_rocks("inspect")

	----------------------------------------
	-- Colorschemes
	----------------------------------------

	-- Transparency
	use("xiyaowong/nvim-transparent")
	-- VSCode
	use("Mofiqul/vscode.nvim")
	-- Diagnostic Colors
	use("folke/lsp-colors.nvim")

	----------------------------------------
	-- Vim
	----------------------------------------

	-- Marks
	use("chentoast/marks.nvim")

	-- Session
	use("rmagatti/auto-session")

	----------------------------------------
	-- Vim: Commands
	----------------------------------------

	-- Proper Buffer Delete command, which does not mess with your window layout
	use("moll/vim-bbye")

	----------------------------------------
	-- Vim: Verbs, Motions
	----------------------------------------

	-- Hop is the Neo Easymotion :D
	use({ "phaazon/hop.nvim", branch = "v2" })
	use("tpope/vim-surround")
	use("tpope/vim-repeat")

	-- Commenting
	use("terrortylor/nvim-comment")
	-- Indent Object: Great for Python
	use("michaeljsmith/vim-indent-object")
	-- Improve default f,t,F,T (search across lines)
	use("rhysd/clever-f.vim") -- VIM
	-- Matchup: Better %
	use("andymass/vim-matchup")
	-- Text Objects based on Treesitter
	use("nvim-treesitter/nvim-treesitter-textobjects")

	----------------------------------------
	-- UI (User Interface)
	----------------------------------------

	----- Components -----
	-- UI: Explorer
	use("kyazdani42/nvim-tree.lua")
	-- UI: Statusline
	use({ "nvim-lualine/lualine.nvim" })
	-- UI: Bufferline
	use({ "akinsho/bufferline.nvim", tag = "v2.6.0" })
	-- UI: Diagnostics
	use({ "folke/trouble.nvim" })

	----- Widgets -----
	-- UI: Implements vim.ui.select and vim.ui.input
	use("stevearc/dressing.nvim")
	-- UI: Implements notifications
	use({ "rcarriga/nvim-notify", tag = "v3.2.1" })
	-- UI: Icon Picker
	use({ "ziontee113/icon-picker.nvim", requires = { "stevearc/dressing.nvim" } })

	----- Modes -----
	-- UI: Zen Mode
	use("folke/zen-mode.nvim")
	-- UI: Twilight - Dim inactive portions of the code
	--		TODO: Switch back to folke/ once
	--		https://github.com/folke/twilight.nvim/issues/15
	--		is sorted
	use("benstockil/twilight.nvim")
	-- UI: Fullscreen mode, maximizes a single window
	use("szw/vim-maximizer")

	----------------------------------------
	-- IDE (Integrated Development Environment)
	----------------------------------------

	-- IDE: Tags
	--use("ludovicchabant/vim-gutentags")
	-- IDE: WhichKey
	use("folke/which-key.nvim")

	-- IDE: Open / Search
	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua", "nvim-telescope/telescope.nvim" },
		commit = "68ac8cfe6754bb656b4f84d6c3dafa421b6f9697",
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", requires = { "nvim-telescope/telescope.nvim" } })

	-- IDE: Terminal
	use("numToStr/FTerm.nvim")

	----------------------------------------
	-- IDE: Code Actions
	----------------------------------------

	-- Provides integration with external tools such as formatters and linters
	use("jose-elias-alvarez/null-ls.nvim")

	----------------------------------------
	-- Editor
	----------------------------------------

	-- Spell check in comments
	use({ "lewis6991/spellsitter.nvim" })

	----------------------------------------
	-- Editor: Actions
	----------------------------------------

	-- DoGe: Documentation Generator
	use({ "kkoomen/vim-doge" })

	----------------------------------------
	-- Editor: Hints
	----------------------------------------

	-- Lightbulb for Code Actions
	use({ "kosayoda/nvim-lightbulb", requires = "antoinemadec/FixCursorHold.nvim" })
	-- Indent lines
	use({ "lukas-reineke/indent-blankline.nvim" })
	-- Display Hex-based Colors
	use({ "norcalli/nvim-colorizer.lua" })
	-- Display range visually while typing in command mode
	use({ "winston0410/range-highlight.nvim", requires = "winston0410/cmd-parser.nvim" })
	-- Rainbow paranthesis (treesitter module)
	use("p00f/nvim-ts-rainbow")
	-- Cursor line: underline current word
	use("RRethy/vim-illuminate") -- VIM
	-- Git Gutter
	use("lewis6991/gitsigns.nvim")
	-- Display context on scroll
	use("nvim-treesitter/nvim-treesitter-context")

	----------------------------------------
	-- Editor: Auto-Configuration
	----------------------------------------

	-- Automatically set the tabwidth
	-- use("tpope/vim-sleuth")

	-- Automatically set 'commentstring' in files with nested languages
	use({ "JoosepAlviste/nvim-ts-context-commentstring", requires = "nvim-treesitter/nvim-treesitter" })

	----------------------------------------
	-- Language Support
	----------------------------------------

	----------------------------------------
	-- Language Support: Language Specific
	----------------------------------------

	-- Lua: REPL for easy development of config/plugins
	use({ "rafcamlet/nvim-luapad", requires = "antoinemadec/FixCursorHold.nvim" })
	-- Lua: LuaDev for Neovim config/plugin support
	use("folke/lua-dev.nvim")

	-- Tex: Vimtex
	use({ "lervag/vimtex" })

	-- Json: Provide access to the SchemaStore
	use("b0o/SchemaStore.nvim")

	-- Rust: rust-tools / LSP
	use("simrat39/rust-tools.nvim")
	-- Rust: crates.nvim
	use({
		"Saecki/crates.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		event = { "BufRead Cargo.toml" },
		config = function()
			-- Add code actions via null-ls
			local crates = require("crates")
			crates.setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})

			-- Inject crates as completion source
			import("cmp", function(cmp)
				vim.api.nvim_create_autocmd("BufRead", {
					group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
					pattern = "Cargo.toml",
					callback = function()
						cmp.setup.buffer({ sources = { { name = "crates" } } })
					end,
				})
			end)

			-- Set mappings
			import("which-key", function(wk)
				wk.register({
					["<localleader>"] = {
						c = {
							name = "Crates",
							t = { crates.toggle, "Crates Toggle" },
							r = { crates.reload, "Crates Reload" },
							--
							v = { crates.show_versions_popup, "Crate Version" },
							f = { crates.show_features_popup, "Crate show Features" },
							d = { crates.show_dependencies_popup, "Crate show Dependencies" },
							--
							u = { crates.update_crate, "Crate Update" },
							U = { crates.update_all_creates, "Crate Upgrade" },
							a = { crates.update_all_crates, "Crate update All" },
							A = { crates.update_all_creates, "Crate Upgrade all" },
							--
							H = { crates.open_homepage, "Crate open Homepage" },
							R = { crates.open_repository, "Crate open Repository" },
							D = { crates.open_documentation, "Crate open Documentation" },
							C = { crates.open_crates_io, "Crate open CratesIO" },
						},
					},
				})
			end)
		end,
	})

	----------------------------------------
	-- Language Support: DAP
	----------------------------------------

	-- General
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", tag = "v1.1.2", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")

	-- Python
	use("mfussenegger/nvim-dap-python")

	----------------------------------------
	-- Language Support: LSP
	----------------------------------------

	-- Language Server Protocol + LSP Config + Mason (auto-install servers)
	use({ "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" })

	-- Completion Sources
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-document-symbol")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("dmitmel/cmp-cmdline-history")
	use("petertriho/cmp-git")
	use("hrsh7th/cmp-omni")
	-- Completion Engine
	use("hrsh7th/nvim-cmp")
	-- Completion Icons
	use("onsails/lspkind.nvim")
	-- Completion Snippet Engine
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	-- Completion Sorter: underscore first (python)
	use("lukas-reineke/cmp-under-comparator")

	----------------------------------------
	-- Language Support: Tree Sitter
	----------------------------------------

	-- Treesitter (syntx highlighting, static analysis)
	use({ "nvim-treesitter/nvim-treesitter" })
	-- Treesitter based indentation
	-- TODO: This should be superceded by standard treesitter, but currently indentation in Python is too shit and needs a different solution
	use({ "yioneko/nvim-yati", ft = { "python" } })

	-- Auto Pairs
	use({ "windwp/nvim-autopairs" })
	-- Endwise (autopairs for lua)
	use("RRethy/nvim-treesitter-endwise")

	----------------------------------------
	-- Language Support: User Interface
	----------------------------------------

	-- User Interface Plugin for LSP
	use({ "kkharji/lspsaga.nvim", branch = "main" })

	-- Show progress of LSP Server
	use("j-hui/fidget.nvim")
	-- Display Virtual Types after functions
	use("jubnzv/virtual-types.nvim")
	-- Display LSP lines below code instead of next
	use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")

	----------------------------------------
	-- Language Support: Environment
	----------------------------------------

	----------------------------------------
	-- Packer Bootstrapping
	----------------------------------------
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

require("import")

----------------------------------------
-- Advanced Plugin Configuration
----------------------------------------

-- ORDER MATTERS
require("quitlox.plugins.colorscheme")
require("quitlox.plugins.bufferline")
-- ORDER MATTERS
require("quitlox.plugins.notify")
-- ORDER MATTERS
require("quitlox.plugins.which_key")

require("quitlox.plugins.comment")
require("quitlox.plugins.completion")
require("quitlox.plugins.dap")
require("quitlox.plugins.nvim_tree")
require("quitlox.plugins.lsp")
require("quitlox.plugins.lualine")
require("quitlox.plugins.luasnip")
require("quitlox.plugins.marks")
require("quitlox.plugins.find")
require("quitlox.plugins.gitsigns")
require("quitlox.plugins.hop")
require("quitlox.plugins.session")
require("quitlox.plugins.terminal")
require("quitlox.plugins.treesitter")
require("quitlox.plugins.trouble")
require("quitlox.plugins.ui")
require("quitlox.plugins.zen")

----------------------------------------
-- Basic Plugin Configuration
----------------------------------------

-- Dependencies
import("nvim-web-devicons", function(devicons)
	devicons.setup({
		default = true,
	})
end)
-- User Interface
import("icon-picker", function(module)
	module.setup({ disable_legacy_commands = true })
end)
-- Editor
import("treesitter-context", function(context)
	context.setup({ mode = "topline" })
end)
import("spellsitter", function(module)
	module.setup({ enable = true })
end)
-- Editor: Hints
import("nvim-lightbulb", function(module)
	module.setup({ autocmd = { enabled = true } })
end)
vim.o.termguicolors = true
import("colorizer", function(module)
	module.setup({ { RGB = false, rgb_fn = true, hsl_fn = true } })
end)
import("range-highlight", function(module)
	module.setup()
end)

-- Language Support: LSP (Completion)
import("nvim-autopairs", function(module)
	module.setup()
end)
-- Language Support: User Interface
-- import("lsp_lines", function(module)
-- 	module.setup()
-- end)
import("fidget", function(module)
	module.setup({ window = { windblend = 100 } })
end)
