-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-rulebook: Linter Rule Support         |
-- +---------------------------------------------------------+

-- stylua: ignore start
vim.keymap.set("n", "<leader>ri", function() require("rulebook").ignoreRule() end, { desc = "Ignore rule" })
vim.keymap.set("n", "<leader>rl", function() require("rulebook").lookupRule() end, { desc = "Lookup rule" })
vim.keymap.set("n", "<leader>ry", function() require("rulebook").yankDiagnosticCode() end, { desc = "Yank rule" })
vim.keymap.set({ "n", "x", "v" }, "<leader>sf", function() require("rulebook").suppressFormatter() end, { desc = "Suppress formatter" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>r", group = "Rule" },
    { "<leader>s", group = "Supress" },
})
