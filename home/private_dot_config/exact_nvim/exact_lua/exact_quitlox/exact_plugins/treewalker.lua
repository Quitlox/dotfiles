-- +---------------------------------------------------------+
-- | aaronik/treewalker.nvim: Walk over the syntaxt tree     |
-- +---------------------------------------------------------+

require("treewalker").setup({})

vim.api.nvim_set_keymap("n", "<C-j>", ":Treewalker Down<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":Treewalker Up<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":Treewalker Left<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":Treewalker Right<CR>", { noremap = true })
