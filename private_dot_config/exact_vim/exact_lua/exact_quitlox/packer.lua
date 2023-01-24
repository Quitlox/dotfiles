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
    use({ "wbthomason/packer.nvim", rocks = "inspect" })

    ----------------------------------------
    -- Dependencies
    ----------------------------------------
    -- Plenary
    use("nvim-lua/plenary.nvim")
    -- Telescope
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

    -- DeviIcons
    use({ "kyazdani42/nvim-web-devicons" })
    -- Make sure requires don't break the entire fucking config
    use("miversen33/import.nvim")
    -- Pretty printing for nice debugging of lua
    use_rocks("inspect")

    ----------------------------------------
    -- Colorschemes
    ----------------------------------------
    use("xiyaowong/nvim-transparent")
    use("Mofiqul/vscode.nvim")
    -- Adds missing highlight group
    use("folke/lsp-colors.nvim")

    ----------------------------------------
    -- Vim
    ----------------------------------------
    -- Marks
    use("chentoast/marks.nvim")
    -- Harpoon Marks
    use("ThePrimeagen/harpoon")

    ----------------------------------------
    -- Vim: Commands
    ----------------------------------------
    -- Proper Buffer Delete command, which does not mess with your window layout
    use("moll/vim-bbye")

    ----------------------------------------
    -- Vim: Verbs, Motions
    ----------------------------------------
    use("tpope/vim-surround")
    use("tpope/vim-repeat")

    -- Motion
    use("ggandor/leap.nvim")
    use({ "ggandor/flit.nvim", requires = "ggandor/leap.nvim" })
    use({ "ggandor/leap-spooky.nvim", requires = "ggandor/leap.nvim" })

    ----- Comment -----
    use("numToStr/Comment.nvim")
    -- Annotation Generator
    use({ "danymat/neogen", requires = "nvim-treesitter/nvim-treesitter" })
    -- Insert Comment Frame/Header
    use("s1n7ax/nvim-comment-frame")
    -- Automatically set 'commentstring' in files with nested languages
    use("JoosepAlviste/nvim-ts-context-commentstring")

    ----- Default Functionality Improved -----
    -- Matchup - Better %
    use("andymass/vim-matchup")

    ----- Text Objects -----
    -- Text Objects --
    use("nvim-treesitter/nvim-treesitter-textobjects")
    -- Indent Text Object (for Python)
    use("michaeljsmith/vim-indent-object")

    ----------------------------------------
    -- UI (User Interface)
    ----------------------------------------
    -- Pretty Folds
    use("anuvyklack/pretty-fold.nvim")

    ----- Components -----
    -- Explorer
    use("kyazdani42/nvim-tree.lua")
    -- Statusline
    use("nvim-lualine/lualine.nvim")
    -- Bufferline
    use({ "akinsho/bufferline.nvim", tag = "v3.1.0" })
    -- Diagnostics
    use("folke/trouble.nvim")

    ----- Widgets -----
    -- Implements vim.ui.select and vim.ui.input
    use("stevearc/dressing.nvim")
    -- Implements notifications
    use({ "rcarriga/nvim-notify", tag = "v3.7.2" })
    -- Icon Picker
    use({ "ziontee113/icon-picker.nvim", requires = { "stevearc/dressing.nvim" } })

    ----- Modes -----
    -- Zen Mode
    use("folke/zen-mode.nvim")
    -- Twilight - Dim inactive portions of the code
    use("folke/twilight.nvim")
    -- Fullscreen mode, maximizes a single window
    use("szw/vim-maximizer")

    ----------------------------------------
    -- IDE (Integrated Development Environment)
    ----------------------------------------
    -- Open / Search
    -- use({ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } })
    use({
        "danielfalk/smart-open.nvim",
        branch = "0.1.x",
        config = function() require("telescope").load_extension("smart_open") end,
        requires = { "kkharji/sqlite.lua", "nvim-telescope/telescope.nvim" },
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    -- Terminal
    use({ "numToStr/FTerm.nvim", disable = true })
    use({ "akinsho/toggleterm.nvim", tag = "*" })
    -- WhichKey
    use({ "folke/which-key.nvim", commit = "6885b669523ff4238de99a7c653d47b081b5506d" })
    -- Tools - Integrations with linters, formatters, etc...
    use("jose-elias-alvarez/null-ls.nvim")
    -- Workspace / Project / Session Manager
    use("GnikDroy/projections.nvim")

    -- Git: DiffView
    use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
    -- Git: Neogit (UI)
    use({ "TimUntersberger/neogit", requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" } })
    -- Git: Blame
    use({ "f-person/git-blame.nvim", config=function()
        vim.g.gitblame_highlight_group = '@tag.delimiter'
    end})

    ----------------------------------------
    -- Editor
    ----------------------------------------

    ----- Editor Actions -----
    -- DoGe - Documentation Generator
    use({ "kkoomen/vim-doge" })
    -- Move - Move around text using ALT
    use({ "echasnovski/mini.move" })

    ----- Editor Hints -----
    -- Indent lines
    use("lukas-reineke/indent-blankline.nvim")
    -- Colorizer - display color of hex-values
    use("NvChad/nvim-colorizer.lua")
    -- Range Highlight in command mode - Display range visually while typing in command mode
    use({ "winston0410/range-highlight.nvim", requires = "winston0410/cmd-parser.nvim" })
    -- Rainbow parenthesis (treesitter module)
    use("p00f/nvim-ts-rainbow")
    -- Highlight word under cursor
    use("RRethy/vim-illuminate")
    -- Todo Comments
    use("folke/todo-comments.nvim")

    -- Git Gutter
    use("lewis6991/gitsigns.nvim")
    -- Breadcrumbs
    use({ "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" })

    ----------------------------------------
    -- Language Support
    ----------------------------------------

    ----- Lua -----
    -- REPL for easy development of config/plugins
    use({ "rafcamlet/nvim-luapad", requires = "antoinemadec/FixCursorHold.nvim" })
    -- LuaDev for Neovim config/plugin support
    use("folke/neodev.nvim")

    ----- Tex -----
    use({ "lervag/vimtex" })
    -- Display Math Equations
    use({
        "jbyuki/nabla.nvim",
        config = function()
            vim.keymap.set("n", "<leader>hl", "<cmd>lua require('nabla').popup()<cr>", { noremap = true })
        end,
    })

    ----- YAML -----
    use({
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function() require("telescope").load_extension("yaml_schema") end,
    })
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    use("b0o/SchemaStore.nvim")
    ----- Rust -----
    use("simrat39/rust-tools.nvim")
    -- Autocompletion in project.toml
    use({ "Saecki/crates.nvim" })

    ----- Yuck -----
    -- the filetype used by ewww
    use("elkowar/yuck.vim")

    ----- Tailwind -----
    -- Add colorizer to completion menu for tailwind colors
    use({ "roobert/tailwindcss-colorizer-cmp.nvim" })

    ----------------------------------------
    -- Language Support: DAP
    ----------------------------------------

    -- General
    use("mfussenegger/nvim-dap")
    use("nvim-telescope/telescope-dap.nvim")
    -- UI
    use({ "rcarriga/nvim-dap-ui", tag = "v2.1.0", requires = { "mfussenegger/nvim-dap" } })
    use("theHamsta/nvim-dap-virtual-text")
    -- Util
    use({ "Weissle/persistent-breakpoints.nvim" })

    -- Python
    use("mfussenegger/nvim-dap-python")

    ----------------------------------------
    -- Language Support: LSP
    ----------------------------------------

    -- Github Copilot
    use("github/copilot.vim")

    -- Language Server Protocol + LSP Config + Mason (auto-install servers)
    use({
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "jay-babu/mason-nvim-dap.nvim",
        "jay-babu/mason-null-ls.nvim",
    })

    -- Completion Sources
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lsp-document-symbol")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("rcarriga/cmp-dap")
    use("dmitmel/cmp-cmdline-history")
    use("petertriho/cmp-git")
    use("hrsh7th/cmp-omni")
    -- Completion Engine
    use("hrsh7th/nvim-cmp")
    -- Completion Icons
    use("onsails/lspkind.nvim")
    -- Completion Snippet Engine
    use({ "L3MON4D3/LuaSnip", tag = "v1.1.*" })
    use("saadparwaiz1/cmp_luasnip")
    -- Completion Sorter: underscore first (python)
    use("lukas-reineke/cmp-under-comparator")

    ----------------------------------------
    -- Language Support: Tree Sitter
    ----------------------------------------

    -- Treesitter (syntx highlighting, static analysis)
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    })
    -- Treesitter based indentation
    -- TODO: This should be superceded by standard treesitter, but currently indentation in Python is too shit and needs a different solution
    use({ "yioneko/nvim-yati", ft = { "python" } })

    -- Auto Pairs
    use({ "windwp/nvim-autopairs" })
    -- Endwise (autopairs for lua)
    use("RRethy/nvim-treesitter-endwise")
    -- AutoTag (autopairs for html/jsx/etc)
    use("windwp/nvim-ts-autotag")

    ----------------------------------------
    -- Language Support: User Interface
    ----------------------------------------

    -- User Interface Plugin for LSP
    use({ "glepnir/lspsaga.nvim", branch = "main" })

    -- Show progress of LSP Server
    -- TODO: Enable after https://github.com/j-hui/fidget.nvim/issues/93
    use({ "j-hui/fidget.nvim", disable = false })
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
    if packer_bootstrap then require("packer").sync() end
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
require("quitlox.plugins.git")
require("quitlox.plugins.lsp")
require('quitlox.plugins.statusline')
-- require("quitlox.plugins.marks")
require("quitlox.plugins.find")
require("quitlox.plugins.motion")
require("quitlox.plugins.nvim_tree")
require("quitlox.plugins.session")
require("quitlox.plugins.terminal")
require("quitlox.plugins.treesitter")
require("quitlox.plugins.trouble")
require("quitlox.plugins.ui")
require("quitlox.plugins.zen")

----------------------------------------
-- Basic Plugin Configuration
----------------------------------------

import("nvim-web-devicons", function(devicons) devicons.setup({ default = true }) end)
import("pretty-fold", function(module) module.setup({ fill_char = "-" }) end)
import("icon-picker", function(module) module.setup({ disable_legacy_commands = true }) end)
import("mini.move", function(move) move.setup() end)
vim.o.termguicolors = true
import(
    "colorizer",
    function(module)
        module.setup({
            filetypes = { "*", javascript = { tailwind = false } },
            user_default_options = {
                RGB = false,
                RRGGBBAA = true,
                RRGGBB = true,
                names = false,
                tailwind = true,
            },
        })
    end
)
import("range-highlight", function(module) module.setup() end)
import(
    "todo-comments",
    function(module)
        module.setup({
            highlight = {
                keyword = "wide",
            },
        })
    end
)
import("nvim-autopairs", function(module) module.setup() end)
import("fidget", function(module) module.setup({ window = { windblend = 100 } }) end)
import("tailwindcss-colorizer-cmp", function(module)
    module.setup({
        color_square_width = 2,
    })
end)
