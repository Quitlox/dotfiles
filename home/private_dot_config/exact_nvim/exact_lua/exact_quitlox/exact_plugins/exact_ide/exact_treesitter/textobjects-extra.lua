-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-various-textobjs: Non-Treesitter      |
-- | Text Objects                                            |
-- +---------------------------------------------------------+

require("various-textobjs").setup({ keymaps = { useDefaults = false } })

-- FIXME: Due to conflicts with targets.vim this doesn't work quite well (you have to be fast)
vim.keymap.set({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword('outer')<CR>")
vim.keymap.set({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword('inner')<CR>")
vim.keymap.set({ "o", "x" }, "al", "<cmd>lua require('various-textobjs').mdLink('outer')<CR>")
vim.keymap.set({ "o", "x" }, "il", "<cmd>lua require('various-textobjs').mdLink('inner')<CR>")
vim.keymap.set({ "o", "x" }, "aC", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>")
vim.keymap.set({ "o", "x" }, "ix", "<cmd>lua require('various-textobjs').htmlAttribute('inner')<CR>")
vim.keymap.set({ "o", "x" }, "aD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>")
vim.keymap.set({ "o", "x" }, "iy", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>")
vim.keymap.set({ "o", "x" }, "ay", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>")
vim.keymap.set({ "n", "o", "x" }, "iD", "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>")
vim.keymap.set({ "n", "o", "x" }, "ax", "<cmd>lua require('various-textobjs').htmlAttribute('outer')<CR>")
vim.keymap.set({ "n", "o", "x" }, "iC", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>")
