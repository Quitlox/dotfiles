-- +---------------------------------------------------------+
-- | LudoPinelli/comment-box.nvim: Comment Box               |
-- +---------------------------------------------------------+

require("comment-box").setup({})

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "gbb", function() require("comment-box").llbox(10) end, { noremap = true, silent = true, desc = "Comment Box" })
vim.keymap.set({ "n", "v" }, "gbl", function() require("comment-box").llline(10) end, { noremap = true, silent = true, desc = "Comment Box Line" })
vim.keymap.set({ "n", "v" }, "gbm", function() require("comment-box").catalog() end, { noremap = true, silent = true, desc = "Comment Box Catalog" })
-- stylua: ignore end
