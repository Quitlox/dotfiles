--+- Setup: Remove /mnt/c/ from Path (Performance) ----------+
local current_path = vim.env.PATH
if current_path then
    local path_parts = vim.split(current_path, ":")
    local filtered_parts = vim.tbl_filter(function(p)
        return not string.find(p, "^/mnt/c/")
    end, path_parts)
    vim.env.PATH = table.concat(filtered_parts, ":")
end

--+- Setup: Delay Notifications -----------------------------+
require("quitlox.util.notify").lazy_notify()

--+- Setup: Bootstrap Rocks.nvim ----------------------------+
require("quitlox.rocks_bootstrap")

--+- Config: Load User Configuration ------------------------+
require("quitlox.config.options")
require("quitlox.config.commands")
require("quitlox.config.autocmds")
require("quitlox.config.mappings")
--+- Config: Environment Specific Configuration -------------+
require("quitlox.config.environment.kitty")
require("quitlox.config.environment.neovide")
require("quitlox.config.environment.wsl")

--+- Setup: Debugging Neovim Configuration ------------------+
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

--+- Config: Colorscheme ------------------------------------+
require("quitlox.colorscheme")

--+- Config: Early Plugins ----------------------------------+
-- Snacks.nvim
local succes, rock_config_mod = pcall(require, "rocks-config")
if succes then
    local succes, _ = pcall(vim.cmd.packadd, "snacks.nvim")
    require("quitlox.plugins.snacks")
end
-- Treesitter
local ok, mod = pcall(require, "nvim-treesitter.configs")
if ok then
    mod.setup({
        indent = { enable = true },
    })
end
