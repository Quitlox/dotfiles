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
            { "<leader>ow",  "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Open Workspace Diagnostics" },
            { "<leader>oq",  "<cmd>TroubleToggle quickfix<cr>",              desc = "Open Quickfix" },
        },
    },
    --  +----------------------------------------------------------+
    --  |     Add mappings for opening Trouble from Telescope      |
    --  +----------------------------------------------------------+
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function(_, opts)
            -- BUG: This works for find_all but not smart_open, the latter resulting in an error
            local trouble = require("trouble.providers.telescope")
            opts.defaults.mappings.i = vim.tbl_extend("keep", opts.defaults.mappings.i, {
                ["<c-t>"] = trouble.open_with_trouble,
            })
        end,
    },
}
