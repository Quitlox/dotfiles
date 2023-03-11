vim.o.termguicolors = true

----------------------------------------------------------------------
--                     Plugin Manager: Install                      --
----------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=v9.7.0", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

----------------------------------------------------------------------
--                      Plugin Manager: Config                      --
----------------------------------------------------------------------

local lazy_config = {
    defaults = {
        lazy = false,
        version = "",
    },
    ui = {
        border = "single",
        custom_keys = {
            ["<localleader>l"] = false,
            ["<localleader>t"] = false,
        },
    },
    diff = {
        cmd = "diffview.nvim",
    },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            paths = { "/home/quitlox/.config/vim" },
        },
    },
}

----------------------------------------------------------------------
--                     Plugin Manager: Plugins                      --
----------------------------------------------------------------------

local plugins = {
    ----------------------------------------
    -- Dependencies
    ----------------------------------------
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons", opts = { default = true }, config = true },
    -- Adds missing highlight group
    { "folke/lsp-colors.nvim" },
    { "folke/which-key.nvim" },

    ----------------------------------------
    -- Vim
    ----------------------------------------

    -- Move - Move around text using ALT
    {
        "echasnovski/mini.move",
        config = function() require("mini.move").setup() end,
    },
    ---------- Commands ----------
    -- Proper Buffer Delete command, which does not mess with your window layout
    { "moll/vim-bbye" }, -- Add lazyload on command
    ---------- Verbs, Motions ----------
    -- { "tpope/vim-surround" },
    { "kylechui/nvim-surround", config = true },
    { "tpope/vim-repeat" },
    ---------- Navigation ----------
    ---------- Improved Defaults ----------
    -- Matchup - Better %
    {
        "andymass/vim-matchup",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                matchup = {
                    enable = true,
                },
            })
        end,
    },
    -- Auto Enable/Disable hlsearch
    { "asiryk/auto-hlsearch.nvim",       config = true },

    ---------- Text Objects ----------
    -- Indent Text Object (for Python)
    { "michaeljsmith/vim-indent-object", ft = "python" },

    ----------------------------------------
    -- Import
    ----------------------------------------

    { import = "quitlox.plugins" },
}

----------------------------------------------------------------------

require("lazy").setup(plugins, lazy_config)

-- Keybinding
require("which-key").register({
    p = { "Vim Plugins", "<cmd>Lazy<cr>" },
}, { prefix = "<leader>v" })
