----------------------------------------------------------------------
--                             Trouble                              --
----------------------------------------------------------------------
-- Implements a replacement for the quickfix and location list windows,
-- also useful for showing diagnostics.

return {
    {
        "folke/trouble.nvim",
        opts = {
            auto_preview = false,
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
            -- stylua: ignore start
            { "<leader>ow", "<cmd>Trouble diagnostics filter.severity={vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN}<cr>", desc = "Open Document Diagnostics" },
            { "<leader>od", "<cmd>Trouble diagnostics filter.severity={vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO}<cr>", desc = "Open All Diagnostics" },
            { "<leader>oq", "<cmd>Trouble quickfix<cr>", desc = "Open Quickfix" },
            -- stylua: ignore end
        },
    },
    require("quitlox.util").legendary({
        { ":TroubleToggle", "Toggle Trouble" },
    }),
}
