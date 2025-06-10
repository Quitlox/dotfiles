-- +---------------------------------------------------------+
-- | shortcuts/no-neck-pain.nvim                             |
-- +---------------------------------------------------------+

require("no-neck-pain").setup({
    width = 120,
    autocmds = {
        skipEnteringNoNeckPainBuffer = true,
    },
})

vim.g.toggle_no_neck_pain = false

Snacks.toggle
    .new({
        name = "Neck Pain",
        set = function(state)
            require("no-neck-pain").toggle()
            vim.g.toggle_no_neck_pain = state
        end,
        get = function()
            return vim.g.toggle_no_neck_pain
        end,
    })
    :map("<leader>Tp")
