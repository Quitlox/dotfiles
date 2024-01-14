local function filter_nt_source_eq(source)
    return function(buf) return vim.b[buf].neo_tree_source == source end
end

local function filter_nt_source_neq(source)
    return function(buf) return vim.b[buf].neo_tree_source ~= source end
end

local function filter_not_relative()
    return function(_buf, win) return vim.api.nvim_win_get_config(win).relative == "" end
end

local function filter_bt(type)
    return function(buf) return vim.bo[buf].buftype == type end
end

return {
    {
        "folke/edgy.nvim",
        ft = { "neo-tree", "Trouble", "qf", "spectre_panel", "help", "NeogitStatus", "neotest-summary", "toggleterm", "OverseerList" },
        opts = {
            left = {
                { ft = "neo-tree", filter = filter_nt_source_neq("document_symbols") },
            },
            right = {
                { ft = "neotest-summary" },
                { title = "Outline", ft = "neo-tree", filter = filter_nt_source_eq("document_symbols") },
                { title = "Overseer", ft = "OverseerList" },
            },
            bottom = {
                { ft = "toggleterm", filter = filter_not_relative() },
                { ft = "NeogitStatus" },
                { ft = "Trouble" },
                { ft = "qf", title = "QuickFix" },
                { ft = "help", size = { height = 20 }, filter = filter_bt("help") },
                { ft = "spectre_panel", size = { height = 0.4 } },
            },

            animate = {
                enabled = false,
            },
            options = {
                left = { size = 40 },
                right = { size = 50 },
                bottom = { size = 0.40 },
            },

            wo = {
                winbar = true,
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
            opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types or { "terminal", "Trouble", "qf", "Outline" }
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
