----------------------------------------------------------------------
--                             Trouble                              --
----------------------------------------------------------------------
-- Implements a replacement for the quickfix and location list windows,
-- also useful for showing diagnostics.

return {
    {
        "folke/trouble.nvim",
        version = "",
        opts = {
            action_keys = {
                close = "q",
                open_split = { "<c-v>" },
                open_vsplit = { "<c-b>" },
                toggle_fold = { "zA", "za", "o" },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "TroubleToggle" },
        keys = {
            { "<leader>odx", "<cmd>TroubleToggle<cr>",                       desc = "Open Trouble" },
            { "<leader>odd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Open Diagnostics Document" },
            { "<leader>odw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Open Diagnostics Workspace" },
            { "<leader>odq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Open Quickfix" },
            { "<leader>ow",  "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Open Workspace Diagnostics" },
            { "<leader>oq",  "<cmd>TroubleToggle quickfix<cr>",              desc = "Open Quickfix" },
        },
    },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>od"] = { name = "Open Diagnostics" },
            },
        },
    },

    --  +----------------------------------------------------------+
    --  |     Add mappings for opening Trouble from Telescope      |
    --  +----------------------------------------------------------+
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function(_, opts)
            opts.defaults.mappings.i = vim.tbl_extend("keep", opts.defaults.mappings.i, {
                ["<c-t>"] = function() require("trouble.providers.telescope").open_with_trouble() end,
            })
        end,
    },
}
