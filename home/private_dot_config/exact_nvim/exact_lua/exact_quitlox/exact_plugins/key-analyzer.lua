-- +---------------------------------------------------------+
-- | meznaric/key-analyzer.nvim: Analyze Key Usage           |
-- +---------------------------------------------------------+

require("key-analyzer").setup({})

-- stylua: ignore start
vim.keymap.set({ "n" }, "<leader>vmv", function() require("key-analyzer").show("v", "") end, { desc = "Analyze Key Usage (visual)" })
vim.keymap.set({ "n" }, "<leader>vmn", function() require("key-analyzer").show("n", "") end, { desc = "Analyze Key Usage (normal)" })
-- stylua: ignore end
