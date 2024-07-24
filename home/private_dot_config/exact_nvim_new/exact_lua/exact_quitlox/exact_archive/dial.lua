-- +---------------------------------------------------------+
-- | monaqa/dial.nvim: Enhanced Increment / Decrement        |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
