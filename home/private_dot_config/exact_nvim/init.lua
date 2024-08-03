-- Experimental Lua loader: https://neovim.io/doc/user/lua.html#vim.loader
vim.loader.enable()

-- Bootstrap rocks.nvim
require("quitlox.rocks_bootstrap")

-- Load configuration
require("quitlox.config.options")
require("quitlox.config.commands")
require("quitlox.config.autocmds")
require("quitlox.config.mappings")

-- Debugging
local osvpath = vim.fn.expand("~") .. "/.local/share/nvim_new/rocks/lib/luarocks/rocks-5.1" .. "/one-small-step-for-vimkind"
if (vim.uv or vim.loop).fs_stat(osvpath) then
    local nvim_config_debug = vim.env.NVIM_CONFIG_DEBUG
    if nvim_config_debug ~= vim.NIL and nvim_config_debug == "y" then
        vim.opt.rtp:prepend(osvpath)
        vim.env.NVIM_CONFIG_DEBUG = ""
        require("osv").launch({ port = 8086 })
        vim.env.NVIM_CONFIG_DEBUG = nvim_config_debug
        vim.print("Press any key to continue")
        vim.fn.getchar()
    end
end

-- Colorscheme
require("quitlox.colorscheme")

-- Load environment specific configuration
require("quitlox.config.environment.kitty")
require("quitlox.config.environment.neovide")

-- TODO:
-- stevearc/profile.nvim
