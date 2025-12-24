-- +---------------------------------------------------------+
-- | saxon1964/neovim-tips.nvim                              |
-- +---------------------------------------------------------+

require("neovim_tips").setup({
    daily_tip = 0,
})

vim.keymap.set("n", "<leader>nto", "<cmd>NeovimTips<cr>", { desc = "Neovim Tips" })
vim.keymap.set("n", "<leader>ntb", "<cmd>NeovimTipsBookmarks<cr>", { desc = "Bookmarked Tips" })
vim.keymap.set("n", "<leader>nte", "<cmd>NeovimTipsEdit<cr>", { desc = "Edit Your Tips" })
vim.keymap.set("n", "<leader>nta", "<cmd>NeovimTipsAdd<cr>", { desc = "Add Your Tip" })
