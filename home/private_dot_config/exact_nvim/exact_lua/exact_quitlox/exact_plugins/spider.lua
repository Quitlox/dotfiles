-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-spider                                |
-- +---------------------------------------------------------+

-- pcall(vim.keymap.del, "n", "<C-w>D")

vim.keymap.set({ "n", "o", "x" }, "<C-b>", "<cmd>lua require('spider').motion('b')<cr>", { desc = "Subword b" })
vim.keymap.set({ "n", "o", "x" }, "<C-w>", "<cmd>lua require('spider').motion('w')<cr>", { desc = "Subword w" })
