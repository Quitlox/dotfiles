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
            vim.keymap.set("n", "[b", "<cmd>lua require('goto-breakpoints').prev()<cr>", { noremap = true })
            vim.keymap.set("n", "]b", "<cmd>lua require('goto-breakpoints').next()<cr>", { noremap = true })
        end,
    },
}