-- +---------------------------------------------------------+
-- | kevinhwang91/nvim-hlslens: Search lens                  |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("hlslens").setup()

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
