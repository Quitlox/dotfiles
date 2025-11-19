-- +---------------------------------------------------------+
-- | folke/snacks.nvim                                       |
-- +---------------------------------------------------------+

local image_opts = require("_plugins.snacks.image")
local notifier_opts = require("_plugins.snacks.notifier")
local picker_config = require("_plugins.snacks.picker")
local styles_opts = require("_plugins.snacks.styles")

require("_plugins.snacks.profile")
local terminal_opts = require("_plugins.snacks.terminal")
require("_plugins.snacks.toggle")
local dashboard_config = require("_plugins.snacks.dashboard")

require("snacks").setup({
    bigfile = { enabled = true, notify = true },
    dashboard = dashboard_config,
    image = image_opts,
    input = { enabled = true },
    lazygit = { win = { style = "my_lazygit" } },
    notifier = notifier_opts,
    picker = picker_config,
    profiler = { enabled = true },
    scratch = { enabled = true },
    -- scroll = { enabled = (vim.fn.exists("g:neovide") == 0) }, -- FIXME: scroll interferes with ]d
    statuscolumn = { enabled = true, left = { "mark", "sign" }, right = { "fold", "git" } },
    styles = styles_opts,
    terminal = terminal_opts,
    toggle = { enabled = true },
    quickfile = { enabled = true, exclude = { "latex" } },
    zen = { enabled = true },
})
