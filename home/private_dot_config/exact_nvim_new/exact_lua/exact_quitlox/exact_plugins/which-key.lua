-- +---------------------------------------------------------+
-- | folke/which-key.nvim: Keyboard Shortcut Helper          |
-- +---------------------------------------------------------+

require("which-key").setup({
    preset = "modern",
    spec = {
        { "<leader><tab>", group = "Tab" },
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>v", group = "Vim" },
        { "<leader>T", group = "Toggle" },
        { "<leader>l", group = "Locate" },
        { "<leader>o", group = "Open" },
        { "<leader>w", group = "Window" },
        { "<leader>m", group = "Miscelleneous" },
        { "<leader>g", group = "Git" },

        { "<localleader>m", group = "Markdown", ft = "markdown" },

        { "<leader>vu", "<cmd>Rocks sync<cr>", desc = "Update Plugins" },

        { "<leader><cr>", hidden = true },
        { "<leader><leader>", hidden = true },
        { "gk", hidden = true },
        { "gj", hidden = true },
    },
    plugins = {
        marks = true,
        registers = true,
        presets = {
            operators = false,
            motions = true, -- FIXME: was false
            text_objects = true, -- FIXME: was false
            windows = false,
            nav = false,
            z = true,
            g = false,
        },
        spelling = {
            enabled = true,
        },
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "", -- symbol used between a key and it's label
        group = " ", -- symbol prepended to a group
        ellipsis = "…",
        colors = false,
    },
    keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    disable = {
        ft = {},
        bt = {},
    },
})

vim.cmd([[hi link WhichKeyIcon WhichKeyDesc]])
