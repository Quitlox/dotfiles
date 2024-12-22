-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-spider                                |
-- +---------------------------------------------------------+

vim.keymap.set({ "n", "o", "x" }, "<C-b>", "<cmd>lua require('spider').motion('b')<cr>", { desc = "Subword b" })
vim.keymap.set({ "n", "o", "x" }, "<C-e>", "<cmd>lua require('spider').motion('w')<cr>", { desc = "Subword b" })
