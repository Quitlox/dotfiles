-- +---------------------------------------------------------+
-- | folke/which-key.nvim: Keyboard Shortcut Helper          |
-- +---------------------------------------------------------+

require("which-key").setup({
    preset = "modern",
    sort = { "order", "group", "natural" },
    delay = function(ctx)
        return ctx.plugin and 0 or 400
    end,
    spec = {
        { "<leader>vu", "<cmd>Rocks sync<cr>", desc = "Update Plugins" },

        { "J", desc = "Join Lines" },

        -- Groups
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
        { "gr", group = "LSP" },

        -- Hide defaults / editor
        { hidden = true, mode = { "n" }, { "Y" }, { "p" }, { "P" }, { "j" }, { "k" }, { ";" }, { "," }, { "n" }, { "N" } },
        { hidden = true, mode = { "n" }, { "r" }, { "t" }, { "T" }, { "f" }, { "t" }, { "T" }, { "<" }, { ">" } },
        { hidden = true, mode = { "n" }, { "<C-w>h" }, { "<C-w>l" }, { "<C-w>j" }, { "<C-w>k" }, { "<C-w>d" } },
        { hidden = true, mode = { "n" }, { "<C-h>" }, { "<C-l>" }, { "<C-j>" }, { "<C-k>" } },
        { "<leader><cr>", hidden = true },
        { "<2-LeftMouse>", hidden = true },

        -- Unmapped Defaults (see mapping.lua)
        { "<C-W><C-d>", hidden = true },
        -- Misc
    },
    plugins = {
        marks = false,
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
