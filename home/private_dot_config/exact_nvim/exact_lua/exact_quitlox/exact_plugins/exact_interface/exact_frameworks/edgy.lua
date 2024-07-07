local function filter_nt_source_eq(source)
    return function(buf)
        return vim.b[buf].neo_tree_source == source
    end
end

local function filter_nt_source_neq(source)
    return function(buf)
        return vim.b[buf].neo_tree_source ~= source
    end
end

local function filter_not_relative()
    return function(_buf, win)
        return vim.api.nvim_win_get_config(win).relative == ""
    end
end

local function filter_bt(type)
    return function(buf)
        return vim.bo[buf].buftype == type
    end
end

return {
    {
        "folke/edgy.nvim",
        ft = {
            "neo-tree",
            "trouble",
            "qf",
            "spectre_panel",
            "help",
            "NeogitStatus",
            "neotest-summary",
            "toggleterm",
            "OverseerList",
            "dap-repl",
            "dapui_console",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
        },
        opts = {
            left = {
                { ft = "neo-tree", filter = filter_nt_source_neq("document_symbols"), wo = { winbar = "    File Explorer" } },
                { ft = "dapui_scopes", size = { height = 0.125 }, wo = { winbar = " 󰒉  Scopes" } },
                { ft = "dapui_breakpoints", size = { height = 0.125 }, wo = { winbar = "    Breakpoints" } },
                { ft = "dapui_stacks", size = { height = 0.125 }, wo = { winbar = "    Call Stack" } },
                { ft = "dapui_watches", size = { height = 0.125 }, wo = { winbar = "   Watches" } },
            },
            right = {
                { ft = "neotest-summary" },
                { title = "Outline", ft = "neo-tree", filter = filter_nt_source_eq("document_symbols"), wo = { winbar = "  󰙅  Outline" } },
            },
            bottom = {
                { ft = "toggleterm", size = { height = 0.4 }, filter = filter_not_relative(), wo = { winbar = "  󰆍  Terminal" } },
                { title = "Overseer", size = { height = 20 }, ft = "OverseerList", wo = { winbar = "    Overseer" } },
                { ft = "NeogitStatus", size = { height = 20 }, wo = { winbar = "  󰊢  Neogit" } },
                { ft = "gitlab", wo = { winbar = "  󰊢  Gitlab" } },

                { ft = "trouble", size = { height = 15 }, wo = { winbar = "󰍉  Trouble" } },
                { ft = "qf", title = "QuickFix", wo = { winbar = "  󰍉  QuickFix" } },
                { ft = "help", size = { height = 20 }, filter = filter_bt("help"), wo = { winbar = "    Help" } },
                { ft = "spectre_panel", size = { height = 0.4 } },

                { ft = "dap-repl", wo = { winbar = "  󰜎 Dap REPL" } },
                { ft = "dapui_console", wo = { winbar = "  󰆍  DAP Console" } },
            },

            animate = {
                enabled = false,
            },
            options = {
                left = { size = 40 },
                right = { size = 50 },
                -- bottom = { size = 0.40 },
            },
            keys = {
                -- FIXME: For some reason, disabling this fixes the wait after q
                ["q"] = false,
            },

            wo = {
                winbar = true,
                foldcolumn = "1",
                foldenable = false,
            },

            fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
        },
        keys = {
            { "<leader>os", "<cmd>lua require('edgy').toggle()<cr>", desc = "Open Sidebar" },
        },
    },
    -- prevent neo-tree from opening files in edgy windows
    {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = function(_, opts)
            opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types or { "terminal", "trouble", "qf", "Outline" }
            table.insert(opts.open_files_do_not_replace_types, "edgy")
        end,
    },

    -- Fix bufferline offsets when edgy is loaded
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function()
            local offset = require("bufferline.offset")
            if not offset.edgy then
                local get = offset.get
                offset.get = function()
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
                        if ret.total_size > 0 then
                            return ret
                        end
                    end
                    return get()
                end
                offset.edgy = true
            end
        end,
    },
}
