----------------------------------------------------------------------
--                      Debug Adapter Protocol                      --
----------------------------------------------------------------------
-- This sub-module configures the debug adapter protocol for debugging.

return {
    { import = "quitlox.plugins.ide.dap" },
    -- Cycle between breakpoints
    {
        "ofirgall/goto-breakpoints.nvim",
        keys = { "[b", "]b" },
        init = function()
            require("quitlox.util.which_key").register({
                ["[b"] = { "<cmd>lua require('goto-breakpoints').prev()<cr>", "Previous Breakpoint" },
                ["]b"] = { "<cmd>lua require('goto-breakpoints').next()<cr>", "Next Breakpoint" },
            }, {noremap=true}
            )
        end,
    },
}
