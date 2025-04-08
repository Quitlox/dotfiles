-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-scissors: Snippets Editor             |
-- +---------------------------------------------------------+

-- stylua: ignore start
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end, { desc = "Snippet: Edit" })
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end, { desc = "Snippet: Add" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>s", group = "Snippets" },
})
