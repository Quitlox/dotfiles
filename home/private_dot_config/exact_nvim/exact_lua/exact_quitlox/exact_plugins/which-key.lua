-- +---------------------------------------------------------+
-- | folke/which-key.nvim: Keyboard Shortcut Helper          |
-- +---------------------------------------------------------+

require("which-key").setup({
    preset = "modern",
    delay = function(ctx)
        return ctx.plugin and 0 or 400
    end,
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
        { "H", hidden = true },
        { "L", hidden = true },
        { "p", hidden = true },
        { "P", hidden = true },
        { "Y", hidden = true },
        { "gk", hidden = true, mode = { "n", "x" } },
        { "gj", hidden = true, mode = { "n", "x" } },
        { "k", hidden = true, mode = { "n", "x" } },
        { "j", hidden = true, mode = { "n", "x" } },
        { "J", desc = "Join Lines" },

        -- Windows
        { "<C-W>h", hidden = true },
        { "<C-W>l", hidden = true },
        { "<C-W>j", hidden = true },
        { "<C-W>k", hidden = true },
        { "<C-W>d", hidden = true },
        -- Unmapped Defaults (see mapping.lua)
        { "<C-W><C-d>", hidden = true },
    },
    plugins = {
        marks = true,
        registers = true,
        presets = {
            operators = true,
            motions = false,
            text_objects = false,
            windows = true,
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
        mappings = false,
    },
    keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
})

vim.cmd([[hi link WhichKeyIcon WhichKeyDesc]])
