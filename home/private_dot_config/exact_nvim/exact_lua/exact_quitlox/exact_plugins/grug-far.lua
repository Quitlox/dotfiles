require("grug-far").setup({})

-- stylua: ignore start
vim.keymap.set("n", "<C-f>", function() require('grug-far').open() end, { desc = "Find & Replace" })
vim.keymap.set("v", "<C-f>", function() require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Find & Replace" })
-- stylua: ignore end
