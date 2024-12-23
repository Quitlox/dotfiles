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

        { "<leader><leader>", group = "Lang" },
        { "<localleader>m", group = "Markdown" },

        { "<leader>vu", "<cmd>Rocks sync<cr>", desc = "Update Plugins" },

        { "<leader><cr>", hidden = true },
        { "<C-W>h", hidden = true },
        { "<C-W>l", hidden = true },
        { "<C-W>j", hidden = true },
        { "<C-W>k", hidden = true },
        { "H", hidden = true },
        { "L", hidden = true },
        { "p", hidden = true },
        { "P", hidden = true },
        { "gk", hidden = true },
        { "gj", hidden = true },
        { "k", hidden = true },
        { "j", hidden = true },
        { "Y", hidden = true },
    },
    plugins = {
        marks = true,
        registers = true,
        presets = {
            operators = false,
            motions = false,
            text_objects = false,
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
})

vim.cmd([[hi link WhichKeyIcon WhichKeyDesc]])
