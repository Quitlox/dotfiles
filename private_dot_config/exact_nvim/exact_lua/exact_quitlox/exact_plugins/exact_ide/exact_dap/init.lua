----------------------------------------------------------------------
--                      Debug Adapter Protocol                      --
----------------------------------------------------------------------
-- This sub-module configures the debug adapter protocol for debugging.

return {
    { import = "quitlox.plugins.ide.dap" },
    {
        "jay-babu/mason-nvim-dap.nvim",
        version = "",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        keys = "<localleader>d",
    },
    -- Cycle between breakpoints
    {
        "ofirgall/goto-breakpoints.nvim",
        keys = { "[b", "]b" },
        init = function()
            require("which-key").register({
                ["[b"] = { "<cmd>lua require('goto-breakpoints').prev()<cr>", "Previous Breakpoint" },
                ["]b"] = { "<cmd>lua require('goto-breakpoints').next()<cr>", "Next Breakpoint" },
            }, { noremap = true })
        end,
    },
}
