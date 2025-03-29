-- +---------------------------------------------------------+
-- | xzbdmw/clasp.nvim: Clever Adaptive Surround Pairs       |
-- +---------------------------------------------------------+

require("clasp").setup({})

vim.keymap.set({ "n", "i" }, "<c-e>", function()
    require("clasp").wrap("prev")
end, { desc = "Wrap Next" })

vim.keymap.set({ "n", "i" }, "<c-;>", function()
    require("clasp").wrap("next")
end, { desc = "Wrap Previous" })
