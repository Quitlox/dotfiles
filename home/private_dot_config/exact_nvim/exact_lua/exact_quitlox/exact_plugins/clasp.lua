-- +---------------------------------------------------------+
-- | xzbdmw/clasp.nvim: Clever Adaptive Surround Pairs       |
-- +---------------------------------------------------------+

require("clasp").setup({})

vim.keymap.set({ "i" }, "<c-l>", function()
    require("clasp").wrap("next")
end, { desc = "Wrap Next" })

vim.keymap.set({ "i" }, "<c-;>", function()
    require("clasp").wrap("prev")
end, { desc = "Wrap Previous" })
