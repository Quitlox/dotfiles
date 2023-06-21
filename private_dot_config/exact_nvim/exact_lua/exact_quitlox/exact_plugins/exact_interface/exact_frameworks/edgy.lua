return {
    {
        "folke/edgy.nvim",
        ft = {
            "neo-tree",
            "Trouble",
            "qf",
            "Outline",
            "spectre_panel",
            "help",
            "NeogitStatus",
            "neotest-summary",
            "toggleterm",
        },
        opts = {
            left = {
                { title = "Neo-Tree", ft = "neo-tree" },
            },
            -- Sidebar Right
            right = {
                -- Symbols Outline
                { ft = "Outline",        open = "SymbolsOutline" },
                { ft = "neotest-summary" },
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
    },
    -- prevent neo-tree from opening files in edgy windows
    {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = function(_, opts)
            opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types or
            { "terminal", "Trouble", "qf", "Outline" }
            table.insert(opts.open_files_do_not_replace_types, "edgy")
        end,
    },

    -- Fix bufferline offsets when edgy is loaded
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function()
            local Offset = require("bufferline.offset")
            if not Offset.edgy then
                local get = Offset.get
                Offset.get = function()
                    if package.loaded.edgy then
                        local layout = require("edgy.config").layout
                        local ret = { left = "", left_size = 0, right = "", right_size = 0 }
                        for _, pos in ipairs({ "left", "right" }) do
                            local sb = layout[pos]
                            if sb and #sb.wins > 0 then
                                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                                ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                                ret[pos .. "_size"] = sb.bounds.width
                            end
                        end
                        ret.total_size = ret.left_size + ret.right_size
                        if ret.total_size > 0 then return ret end
                    end
                    return get()
                end
                Offset.edgy = true
            end
        end,
    },
}
