-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-various-textobjs: Non-Treesitter      |
-- | Text Objects                                            |
-- +---------------------------------------------------------+

require("various-textobjs").setup({ keymaps = { useDefaults = false } })

vim.keymap.set({ "o", "x" }, "aS", "<cmd>lua require('various-textobjs').subword('outer')<CR>")
vim.keymap.set({ "o", "x" }, "iS", "<cmd>lua require('various-textobjs').subword('inner')<CR>")
