-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-scissors: Snippets Editor             |
-- +---------------------------------------------------------+

require("scissors").setup({
    editSnippetPopup = {},
    jsonFormatter = "jq",
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end, { desc = "Snippet: Edit" })
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end, { desc = "Snippet: Add" })
-- stylua: ignore end
