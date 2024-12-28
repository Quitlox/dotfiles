-- +---------------------------------------------------------+
-- | icholy/lsplinks.nvim: Support for                       |
-- | textDocument/documentLink                               |
-- +---------------------------------------------------------+

require("lsplinks").setup()
vim.keymap.set("n", "gx", "<cmd>lua require('lsplinks').gx()<cr>", { desc = "Go to document link" })
