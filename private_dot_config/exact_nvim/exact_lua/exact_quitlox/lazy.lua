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
        enabled = false,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            paths = { "/home/quitlox/.config/vim", "C:/Users/witloxkhd/.config/vim" },
        }
    },
}

----------------------------------------------------------------------
--                     Plugin Manager: Plugins                      --
----------------------------------------------------------------------

local plugins = {
    ----------------------------------------
    -- Vim
    ----------------------------------------

    ---------- Commands ----------
    -- Proper Buffer Delete command, which does not mess with your window layout
    { "moll/vim-bbye" }, -- Add lazyload on command
    ---------- Verbs, Motions ----------
    -- { "tpope/vim-surround" },
    { "kylechui/nvim-surround",      config = true },
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
    p = { "<cmd>Lazy<cr>", "Plugins" },
}, { prefix = "<leader>v" })

require("quitlox.plugins.config.include.keybindings")
