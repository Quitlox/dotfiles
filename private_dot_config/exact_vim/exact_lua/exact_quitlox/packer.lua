-- REPL: iron.nvim

-- TODO
-- telescope-bibtex
-- nvim-telescope/telescope-file-browser.nvim

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
	-- Buffers: Commands to manage buffers
	-- use"Asheq/close-buffers.vim"

	----------------------------------------
	-- Vim: Commands
	----------------------------------------

	-- Proper Buffer Delete command, which does not mess with your window layout
	use("moll/vim-bbye")
	-- Command to close all other buffers
	use("vim-scripts/BufOnly.vim")

	----------------------------------------
	-- Vim: Verbs, Motions
	----------------------------------------

	use("easymotion/vim-easymotion")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")

	-- Commenting
	use("terrortylor/nvim-comment")
	-- Indent Object: Great for Python
	use("michaeljsmith/vim-indent-object")
	-- Improve default f,t,F,T (search across lines)
	use("rhysd/clever-f.vim") -- VIM

	----------------------------------------
	-- UI (User Interface)
	----------------------------------------

	-- Components

	-- UI: Explorer
	use("kyazdani42/nvim-tree.lua")
	-- UI: Statusline
	use({ "nvim-lualine/lualine.nvim" })
	-- UI: Bufferline
	use("akinsho/bufferline.nvim")

	-- Modes (TODO: think of better name)

	-- UI: Zen Mode
	use("folke/zen-mode.nvim")

	-- UI: Twilight - Dim inactive portions of the code
	--		TODO: Switch back to folke/ once
	--		https://github.com/folke/twilight.nvim/issues/15
	--		is sorted
	use("benstockil/twilight.nvim")

	-- Widgets

	-- UI: Implements vim.ui.select and vim.ui.input
	use("stevearc/dressing.nvim")
	-- UI: Implements notifications
	use("rcarriga/nvim-notify")
	-- UI: Icon Picker
	use({ "ziontee113/icon-picker.nvim", requires = { "stevearc/dressing.nvim" } })

	----------------------------------------
	-- IDE (Integrated Development Environment)
	----------------------------------------

	-- IDE: Tags
	use("ludovicchabant/vim-gutentags")
	-- IDE: Better Session management
	use("tpope/vim-obsession")
	-- IDE: WhichKey
	use("folke/which-key.nvim")

	-- IDE: Open / Search
	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua", "nvim-telescope/telescope.nvim" },
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

	----------------------------------------
	-- Editor: Auto-Configuration
	----------------------------------------

	-- Automatically set the tabwidth
	-- use("tpope/vim-sleuth")
	-- Intelligently reopn files at your last edit position in vim
	use("farmergreg/vim-lastplace")

	-- Automatically set 'commentstring' in files with nested languages
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
				},
			})
		end,
		requires = "nvim-treesitter/nvim-treesitter",
	})

	----------------------------------------
	-- Language Support
	----------------------------------------

	-- Lua REPL for easy development of config/plugins
	use({ "rafcamlet/nvim-luapad", requires = "antoinemadec/FixCursorHold.nvim" })

	----------------------------------------
	-- Language Support: LSP (Completion)
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
	use("f3fora/cmp-spell")
	use("petertriho/cmp-git")
	-- Completion Engine
	use("hrsh7th/nvim-cmp")
	-- Completion Icons
	use("onsails/lspkind.nvim")
	-- Completion Snippet Engine
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Completion Signature Help
	use("ray-x/lsp_signature.nvim")

	-- Auto Pairs
	use({ "windwp/nvim-autopairs" })

	----------------------------------------
	-- Language Support: Tree Sitter
	----------------------------------------

	-- Treesitter (syntx highlighting, static analysis)
	use({ "nvim-treesitter/nvim-treesitter" })
	-- DoGe: Documentation Generator
	use({
		"kkoomen/vim-doge",
		config = function()
			vim.g.doge_doc_standard_python = "google"
			vim.cmd([[call doge#install()]])
		end,
	})
	-- Treesitter based indentation
	-- TODO: This should be superceded by standard treesitter, but currently indentation in Python is too shit and needs a different solution
	use({ "yioneko/nvim-yati", ft = { "python" } })

	----------------------------------------
	-- Language Support: User Interface
	----------------------------------------
	-- These are User Inteface plugins specifically for LSP functionality

	--	Rename: Cosmic UI - Fancy replacements for default vim functionality (rename, code-action)
	-- use({ "CosmicNvim/cosmic-ui", requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" } })
	--	Custom UI for LSP Actions
	-- use({ "RishabhRD/nvim-lsputils", requires = "RishabhRD/popfix" })
	-- User Interface Plugin for LSP
	use({ "kkharji/lspsaga.nvim" })

	-- Show progress of LSP Server
	use("j-hui/fidget.nvim")
	-- Display Virtual Types after functions
	use("jubnzv/virtual-types.nvim")

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

----------------------------------------
-- Basic Plugin Configuration
----------------------------------------

-- Dependencies
require("nvim-treesitter.install").update({ with_sync = true })
require("nvim-web-devicons").setup({
	default = true,
})
-- User Interface
require("icon-picker").setup({ disable_legacy_commands = true })
-- Editor
--require("spellsitter").setup({ enable = false })
--DIED^?
-- Editor: Hints
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
vim.o.termguicolors = true
require("colorizer").setup()
require("range-highlight").setup({})
require("gitsigns").setup()

-- Language Support: LSP (Completion)
require("lsp_signature").setup({})
require("nvim-autopairs").setup({})
-- Language Support: User Interface
require("fidget").setup({ window = { windblend = 100 } })

----------------------------------------
-- Advanced Plugin Configuration
----------------------------------------

-- ORDER MATTERS
require("quitlox.plugins.colorscheme")
require("quitlox.plugins.bufferline")

-- ORDER MATTERS
require("quitlox.plugins.which_key")

require("quitlox.plugins.comment")
require("quitlox.plugins.completion")
require("quitlox.plugins.nvim_tree")
require("quitlox.plugins.indent_line")
require("quitlox.plugins.lsp")
require("quitlox.plugins.lualine")
require("quitlox.plugins.marks")
require("quitlox.plugins.open")
require("quitlox.plugins.terminal")
require("quitlox.plugins.treesitter")
require("quitlox.plugins.ui")
require("quitlox.plugins.zen")
