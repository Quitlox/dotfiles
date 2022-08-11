import("hop", function(hop)
	hop.setup({})

    vim.keymap.set('n', '<leader><leader>h', '<cmd>HopChar1<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>l', '<cmd>HopChar1<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>w', '<cmd>HopWord<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>j', '<cmd>HopLineStartAC<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>k', '<cmd>HopLineStartBC<cr>', {noremap=true,silent=true})
end)
