return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
        left = {
            -- {
            --     title = "Neo-Tree Buffers",
            --     ft = "neo-tree",
            --     filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
            --     pinned = true,
            --     open = "Neotree position=top buffers",
            --     size = { height = 0.2 },
            -- },
            {
                title = "Neo-Tree",
                ft = "neo-tree",
                -- filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
                -- size = { height = 0.5 },
            },
            -- {
            --     title = "Neo-Tree Git",
            --     ft = "neo-tree",
            --     filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
            --     pinned = true,
            --     open = "Neotree position=right git_status",
            --     size = { height = 0.2 },
            -- },
        },
        -- Sidebar Right
        right = {
            -- Symbols Outline
            {
                ft = "Outline",
                pinned = true,
                open = "SymbolsOutline",
            },
            {
                ft = "neotest-summary",
            },
        },
        -- Sidebar Bottom
        bottom = {
            -- Terminal
            {
                ft = "toggleterm",
                -- exclude floating windows
                filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
            },
            -- Git
            { ft = "NeogitStatus" },
            -- Diagnostics
            { ft = "Trouble" },
            -- Quickfix
            { ft = "qf",          title = "QuickFix" },
            -- Help
            {
                ft = "help",
                size = { height = 20 },
                filter = function(buf) return vim.bo[buf].buftype == "help" end,
            },
            { ft = "spectre_panel", size = { height = 0.4 } },
        },

        animate = {
            enabled = false,
        },
        options = {
            left = { size = 40 },
            right = { size = 50 },
            bottom = { size = 0.35 },
        },

        wo = {
            winbar = true,
        },

        fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
    },
    config = function(_, opts)
        require("edgy").setup(opts)

        require("which-key").register({
            ["<leader>"] = {
                o = {
                    s = { "<cmd>lua require('edgy').toggle()<cr>", "Open Sidebar" },
                },
            },
        })
    end,
}
