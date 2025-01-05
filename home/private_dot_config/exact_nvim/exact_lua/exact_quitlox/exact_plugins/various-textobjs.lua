-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-various-textobjs: Non-Treesitter      |
-- | Text Objects                                            |
-- +---------------------------------------------------------+

require("various-textobjs").setup({ keymaps = { useDefaults = false } })

vim.keymap.set({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword('outer')<CR>", { desc = "Subword" })
vim.keymap.set({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword('inner')<CR>", { desc = "Subword" })
vim.keymap.set({ "o", "x" }, "ax", "<cmd>lua require('various-textobjs').mdLink('outer')<CR>", { desc = "Markdown Link" })
vim.keymap.set({ "o", "x" }, "ix", "<cmd>lua require('various-textobjs').mdLink('inner')<CR>", { desc = "Markdown Link" })
-- vim.keymap.set({ "o", "x" }, "aC", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>")
-- vim.keymap.set({ "o", "x" }, "iC", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>")
vim.keymap.set({ "o", "x" }, "id", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", { desc = "Python Triple Quotes" })
vim.keymap.set({ "o", "x" }, "ad", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", { desc = "Python Triple Quotes" })
-- vim.keymap.set({ "o", "x" }, "aD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>")
-- vim.keymap.set({ "o", "x" }, "iD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>")
-- vim.keymap.set({ "o", "x" }, "ax", "<cmd>lua require('various-textobjs').htmlAttribute('outer')<CR>")
-- vim.keymap.set({ "o", "x" }, "ix", "<cmd>lua require('various-textobjs').htmlAttribute('inner')<CR>")
