-- Experimental Lua loader: https://neovim.io/doc/user/lua.html#vim.loader
vim.loader.enable()

-- Bootstrap rocks.nvim
require("quitlox.rocks_bootstrap")

-- Load configuration
require("quitlox.config.options")
require("quitlox.config.commands")
require("quitlox.config.autocmds")
require("quitlox.config.mappings")

-- Load environment specific configuration
require("quitlox.config.environment.kitty")
require("quitlox.config.environment.neovide")

-- Load vim plugins
vim.cmd([[source ./settings/plugins/vimtex.vim]])

-- Manually load colorscheme
require("rocks").packadd("")

-- TODO:

-- stevearc/profile.nvim
