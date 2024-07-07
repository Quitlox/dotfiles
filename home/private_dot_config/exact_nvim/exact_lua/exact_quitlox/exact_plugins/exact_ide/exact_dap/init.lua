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
    },
    -- Cycle between breakpoints
    {
        "ofirgall/goto-breakpoints.nvim",
        keys = {
            { "[b", function() require("goto-breakpoints").prev() end, desc = "Previous Breakpoint" },
            { "]b", function() require("goto-breakpoints").next() end, desc = "Next Breakpoint" },
        },
    },
    {
        "Weissle/persistent-breakpoints.nvim",
        config = true,
        opts = {
            load_breakpoints_event = { "BufReadPost" },
        },
    },
}
