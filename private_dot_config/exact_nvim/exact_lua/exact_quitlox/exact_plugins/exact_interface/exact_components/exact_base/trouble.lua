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
            { "<leader>od", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Open Document Diagnostics" },
            { "<leader>ow", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Open Workspace Diagnostics" },
            { "<leader>oq", "<cmd>TroubleToggle quickfix<cr>", desc = "Open Quickfix" },
        },
    },
    require("quitlox.util").legendary({
        { ":TroubleToggle", "Toggle Trouble" },
    }),
}
