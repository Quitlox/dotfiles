return {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    -- Causes hiccups (especiialy when using tailwind)
    -- BUG: https://github.com/hrsh7th/nvim-cmp/issues/1613
    config = function()
        require("lsp_signature").setup({
            hint_prefix = "  ",
            handler_opts = {
                border = "rounded",
            },
            floating_window = true,
            wrap = true,
        })
    end,
}
