-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-rulebook: Linter Rule Support         |
-- +---------------------------------------------------------+

-- stylua: ignore start
vim.keymap.set("n", "<leader>ri", function() require("rulebook").ignoreRule() end, { desc = "Rule Ignore" })
vim.keymap.set("n", "gri", function() require("rulebook").ignoreRule() end, { desc = "Rule Ignore" })
vim.keymap.set("n", "<leader>rl", function() require("rulebook").lookupRule() end, { desc = "Rule Lookup" })
vim.keymap.set("n", "grl", function() require("rulebook").lookupRule() end, { desc = "Rule Lookup" })
vim.keymap.set("n", "<leader>ry", function() require("rulebook").yankDiagnosticCode() end, { desc = "Rule Yank" })
vim.keymap.set({ "n", "x", "v" }, "<leader>rs", function() require("rulebook").suppressFormatter() end, { desc = "Suppress formatter" })
vim.keymap.set({ "n", "x", "v" }, "grs", function() require("rulebook").suppressFormatter() end, { desc = "Suppress formatter" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>r", group = "Rule" },
})
