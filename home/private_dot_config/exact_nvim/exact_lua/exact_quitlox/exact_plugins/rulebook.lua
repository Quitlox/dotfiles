-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-rulebook: Linter Rule Support         |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<leader>ri", function() require("rulebook").ignoreRule() end, { desc = "Ignore rule" })
vim.keymap.set("n", "<leader>rl", function() require("rulebook").lookupRule() end, { desc = "Lookup rule" })
vim.keymap.set("n", "<leader>ry", function() require("rulebook").yankDiagnosticCode() end, { desc = "Yank diagnostic code" })
vim.keymap.set({ "n", "x" }, "<leader>sf", function() require("rulebook").suppressFormatter() end, { desc = "Suppress formatter" })
