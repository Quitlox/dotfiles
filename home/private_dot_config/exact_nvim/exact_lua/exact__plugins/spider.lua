-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-spider                                |
-- +---------------------------------------------------------+

vim.keymap.set({ "n", "o", "x" }, "H", "<cmd>lua require('spider').motion('b')<cr>", { desc = "Subword b" })
vim.keymap.set({ "n", "o", "x" }, "L", "<cmd>lua require('spider').motion('w')<cr>", { desc = "Subword w" })
