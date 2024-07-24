-- +---------------------------------------------------------+
-- | LudoPinelli/comment-box.nvim: Comment Box               |
-- +---------------------------------------------------------+

vim.keymap.set({ "n", "v" }, "gbb", function() require("comment-box").llbox(10) end, { noremap = true, silent = true, desc = "Comment Box" })
vim.keymap.set({ "n", "v" }, "gbl", function() require("comment-box").lcline(10) end, { noremap = true, silent = true, desc = "Comment Box Line" })
vim.keymap.set({ "n", "v" }, "gbm", function() require("comment-box").catalog() end, { noremap = true, silent = true, desc = "Comment Box Catalog" })
