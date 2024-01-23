return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        init = function()
            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
        end,
        opts = {
            open_files_do_not_replace_types = { "terminal", "trouble", "qf", "Neogit" },

            -- Project.
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
            },

            window = {
                mappings = {
                    ["<cr>"] = "open_with_window_picker",
                    ["o"] = "open",
                    ["<esc>"] = "revert_preview",
                    ["b"] = "open_vsplit",
                    ["v"] = "open_split",
                    ["s"] = "noop",
                    ["S"] = "noop",
                },
            },

            filesystem = {
                -- time the current file is changed while the tree is open.
                group_empty_dirs = true,
            },
            document_symbols = {
                window = {
                    mappings = {
                        ["<cr>"] = "jump_to_symbol",
                        ["o"] = "toggle_node",
                        ["i"] = "jump_to_symbol",
                        ["A"] = "noop",
                        ["d"] = "noop",
                        ["y"] = "noop",
                        ["x"] = "noop",
                        ["p"] = "noop",
                        ["c"] = "noop",
                        ["m"] = "noop",
                        ["a"] = "noop",
                        ["/"] = "filter",
                        ["f"] = "filter_on_submit",
                    },
                },
            },

            sources = {
                "filesystem",
                "buffers",
                "git_status",
                "document_symbols",
            },
            source_selector = {
                winbar = true,
                statusline = false,
                sources = {
                    {
                        source = "filesystem",
                        display_name = " 󰉓  Files ",
                    },
                    {
                        source = "buffers",
                        display_name = "   Buffers ",
                    },
                    {
                        source = "git_status",
                        display_name = " 󰊢  Git ",
                    },
                    -- {
                    --     source = "document_symbols",
                    --     display_name = "  Outline ",
                    -- },
                },
            },
        },
        keys = {
            { "<leader>lf", "<cmd>Neotree source=filesystem reveal=true<cr>", desc = "Locate File" },
            { "<leader>oe", "<cmd>Neotree source=filesystem reveal=false toggle=true<cr>", desc = "Open Explorer" },
            { "<leader>oo", "<cmd>Neotree position=right document_symbols reveal=true<cr>", desc = "Open Outline" },
            { "<leader>ls", "<cmd>Neotree position=right document_symbols reveal=true<cr>", desc = "Locate Symbol" },
        },
    },
    {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        lazy = true,
        name = "window-picker",
        opts = {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
                bo = {
                    -- if the file type is one of following, the window will be ignored
                    filetype = { "neo-tree", "neo-tree-popup", "notify", "neotest-summary", "NeogitStatus", "help", "Outline" },
                    -- if the buffer type is one of following, the window will be ignored
                    buftype = { "terminal", "quickfix" },
                },
            },
        },
    },
}
