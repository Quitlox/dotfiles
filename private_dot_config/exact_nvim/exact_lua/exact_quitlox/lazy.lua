vim.o.termguicolors = true

-- Experimental Lua loader: https://neovim.io/doc/user/lua.html#vim.loader
vim.loader.enable()

----------------------------------------------------------------------
--                     Plugin Manager: Install                      --
----------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
}) end
vim.opt.rtp:prepend(lazypath)

----------------------------------------------------------------------
--                      Plugin Manager: Config                      --
----------------------------------------------------------------------

local lazy_config = {
    defaults = {
        lazy = false,
    },
    ui = {
        icons = {
            plugin = " ",
        },
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
    change_detection = {
        enabled = false,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            paths = { "/home/quitlox/.config/vim", "C:/Users/witloxkhd/.config/vim" },
        },
    },
}

----------------------------------------------------------------------
--                     Plugin Manager: Plugins                      --
----------------------------------------------------------------------

local plugins = {
    ----------------------------------------
    -- Vim
    ----------------------------------------
    { "jbyuki/quickmath.nvim", cmd = "Quickmath" },
    require("quitlox.util").legendary({ { ":Quickmath", "Activate Quickmath" } }),

    ---------- Commands ----------
    -- Proper Buffer Delete command, which does not mess with your window layout
    { "moll/vim-bbye" }, -- Add lazyload on command
    ---------- Verbs, Motions ----------
    -- { "tpope/vim-surround" },
    { "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
    { "tpope/vim-repeat" },
    ---------- Navigation ----------

    ----------------------------------------
    -- Import
    ----------------------------------------

    { import = "quitlox.plugins" },

    require("quitlox.util").whichkey({
        ["<leader>vp"] = { "<cmd>Lazy<cr>", "Plugins" },
    }),
}

----------------------------------------------------------------------

require("lazy").setup(plugins, lazy_config)
require("quitlox.config")
