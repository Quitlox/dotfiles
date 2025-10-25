-- +---------------------------------------------------------+
-- | edgy-group.nvim: Group Edgy Panels                      |
-- +---------------------------------------------------------+

require("edgy-group").setup({
    groups = {
        left = {
            { icon = " ", titles = { "Neo-Tree" } },
            { icon = " ", titles = { "DAP Scopes", "DAP Breakpoints", "DAP Call Stack", "DAP Watches" } },
        },
        right = {
            { icon = " ", titles = { "Neotest" } },
            { icon = " ", titles = { "Outline" } },
            { icon = " ", titles = { "Overseer Jobs" } },
        },
        bottom = {
            { icon = " ", titles = { "Overseer" } },
            { icon = " ", titles = { "Neogit" } },
            -- { icon = "󰮠 ", titles = { "Gitlab" } },

            { icon = " ", titles = { "Trouble", "QuickFix" } },
            -- { icon = " ", titles = { "Help" } },
            { icon = " ", titles = { "Find & Replace" } },
            { icon = " ", titles = { "DAP REPL", "DAP Console" } },
            { icon = " ", titles = { "Terminal" } },
        },
        top = {},
    },
    statusline = {
        clickable = true,
        colored = true,
        colors = {
            active = {
                bg = "StatusLineNC",
                fg = require("catppuccin.palettes").get_palette().green,
            },
        },
    },
})
