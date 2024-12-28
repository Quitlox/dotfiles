-- +---------------------------------------------------------+
-- | monaqa/dial.nvim: Enhanced Increment / Decrement        |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<C-a>", function() require("dial.map").inc_normal() end, { noremap = true })
vim.keymap.set("n", "<C-x>", function() require("dial.map").dec_normal() end, { noremap = true })
vim.keymap.set("v", "<C-a>", function() require("dial.map").inc_visual() end, { noremap = true })
vim.keymap.set("v", "<C-x>", function() require("dial.map").dec_visual() end, { noremap = true })
