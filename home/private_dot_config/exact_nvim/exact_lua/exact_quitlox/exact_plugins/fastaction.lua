-- +---------------------------------------------------------+
-- | Chaitanyabsprip/fastaction.nvim                         |
-- +---------------------------------------------------------+

require("fastaction").setup({})

vim.keymap.set("n", "gra", '<cmd>lua require("fastaction").code_action()<cr>', { silent = true, desc = "Code Action" })
vim.keymap.set("v", "gra", '<cmd>lua require("fastaction").range_code_action()<cr>', { silent = true, desc = "Code Action (Range)" })
