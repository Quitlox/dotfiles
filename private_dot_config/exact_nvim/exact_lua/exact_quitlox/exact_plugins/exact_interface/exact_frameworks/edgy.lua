return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
        left = {
            -- "NvimTree",
        },
        -- Sidebar Right
        right = {
            -- Symbols Outline
            {
                ft = "Outline",
                pinned = true,
                open = "SymbolsOutline",
                size = { width = 60 },
            },
        },
        -- Sidebar Bottom
        bottom = {
            -- Terminal
            {
                ft = "toggleterm",
                size = { height = 0.4 },
                -- exclude floating windows
                filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
            },
            -- Diagnostics
            "Trouble",
            -- Quickfix
            { ft = "qf",            title = "QuickFix" },
            -- Help
            {
                ft = "help",
                size = { height = 20 },
                filter = function(buf) return vim.bo[buf].buftype == "help" end,
            },
            { ft = "spectre_panel", size = { height = 0.4 } },
        },

        wo = {
            winfixwidth = false,
        },

        fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
    },
}
