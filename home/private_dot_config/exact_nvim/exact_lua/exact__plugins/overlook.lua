-- +---------------------------------------------------------+
-- | WilliamHsieh/overlook.nvim                              |
-- +---------------------------------------------------------+

require("overlook").setup({})

-- stylua: ignore start
vim.keymap.set("n", "gD", function() require("overlook.api").peek_definition() end, { desc = "Overlook: Peek definition" })
vim.keymap.set("n", "<leader>pu", function() require("overlook.api").restore_popup() end, { desc = "Overlook: Restore popup" })
vim.keymap.set("n", "<leader>pr", function() require("overlook.api").restore_all_popups() end, { desc = "Overlook: Restore all popups" })
-- stylua: ignore end
