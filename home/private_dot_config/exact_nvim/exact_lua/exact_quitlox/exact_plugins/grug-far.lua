-- +---------------------------------------------------------+
-- | MagicDuck/grug-far.nvim                                 |
-- +---------------------------------------------------------+

require("grug-far").setup({})

-- stylua: ignore start
vim.keymap.set("n", "<C-f>", function() require('grug-far').open() end, { desc = "Find & Replace (all files)" })
vim.keymap.set("n", "<C-F>", function() require('grug-far').open({ prefills = { paths = vim.fn.expand("%") } }) end, { desc = "Find & Replace (current file)" })
vim.keymap.set("v", "<C-f>", ":<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand('%') } })", { desc = "Find & Replace (current file)" })
vim.keymap.set("v", "<C-F>", ":<C-u>lua require('grug-far').with_visual_selection()", { desc = "Find & Replace (all files)" })
-- stylua: ignore end
