return {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    -- Causes hiccups (especiialy when using tailwind)
    -- BUG: https://github.com/hrsh7th/nvim-cmp/issues/1613
    config = function()
        require("lsp_signature").setup({
            bind = true,
            handler_opts = {
                border = "single",
            },
            hint_prefix = " ",
            floating_window = false,
            wrap = false,
        })
    end,
}
