----------------------------------------------------------------------
--                             Trouble                              --
----------------------------------------------------------------------
-- Implements a replacement for the quickfix and location list windows,
-- also useful for showing diagnostics.

return {
    "folke/trouble.nvim",
    opts = {
        action_keys = {
            close = "q",
            open_split = { "<c-v>" },
            open_vsplit = { "<c-b>" },
            toggle_fold = { "zA", "za", "o" },
        },
    },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = true,
    init = function()
        require("which-key").register({
            d = {
                name = "Diagnostics",
                x = { "<cmd>TroubleToggle<cr>", "Open Trouble" },
                d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Open Diagnostics Document " },
                w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Open Diagnostics Workspace " },
                q = { "<cmd>TroubleToggle quickfix_diagnostics<cr>", "Open Quickfix" },
            },
        }, { prefix = "<leader>o", noremap = true })
    end,
}
