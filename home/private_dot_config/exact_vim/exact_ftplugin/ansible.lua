vim.keymap.set('v', '<localleader>r', function() require('ansible').run() end, { buffer = true, silent = true })
vim.keymap.set('n', '<localleader>r', ":w<CR> :lua require('ansible').run()<CR>", { buffer = true, silent = true })
