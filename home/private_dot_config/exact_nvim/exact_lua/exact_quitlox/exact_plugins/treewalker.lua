-- +---------------------------------------------------------+
-- | aaronik/treewalker.nvim: Walk over the syntaxt tree     |
-- +---------------------------------------------------------+

require("treewalker").setup({})

vim.api.nvim_set_keymap("n", "<A-j>", ":Treewalker Down<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", ":Treewalker Up<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-h>", ":Treewalker Left<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-l>", ":Treewalker Right<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "gh", ":Treewalker SwapLeft<CR>", { noremap = true, silent = true, desc = "Swap Left" })
vim.api.nvim_set_keymap("n", "gl", ":Treewalker SwapRight<CR>", { noremap = true, silent = true, desc = "Swap Right" })
vim.api.nvim_set_keymap("n", "gj", ":Treewalker SwapDown<CR>", { noremap = true, silent = true, desc = "Swap Down" })
vim.api.nvim_set_keymap("n", "gk", ":Treewalker SwapUp<CR>", { noremap = true, silent = true, desc = "Swap Up" })
