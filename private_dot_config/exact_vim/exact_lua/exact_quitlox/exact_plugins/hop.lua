local directions = require('hop.hint').HintDirection

import("hop", function(hop)
	hop.setup({})

    vim.keymap.set('n', '<leader><leader>h', '<cmd>HopChar1<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>l', '<cmd>HopChar1<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>w', '<cmd>HopWord<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>j', '<cmd>HopLineStartAC<cr>', {noremap=true,silent=true})
    vim.keymap.set('n', '<leader><leader>k', '<cmd>HopLineStartBC<cr>', {noremap=true,silent=true})
    vim.keymap.set('v', '<leader><leader>j', '<cmd>HopLineStartAC<cr>', {noremap=true,silent=true})
    vim.keymap.set('v', '<leader><leader>k', '<cmd>HopLineStartBC<cr>', {noremap=true,silent=true})

    -- vim.keymap.set('', 'f', function()
    --   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
    -- end, {remap=true})
    -- vim.keymap.set('', 'F', function()
    --   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
    -- end, {remap=true})
    -- vim.keymap.set('', 't', function()
    --   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
    -- end, {remap=true})
    -- vim.keymap.set('', 'T', function()
    --   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
    -- end, {remap=true})
end)

