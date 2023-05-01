-- General Configurations
vim.cmd('source ~/.config/vim/settings/options.vim')
vim.cmd('source ~/.config/vim/settings/keybindings.vim')
vim.cmd('source ~/.config/vim/settings/wildmenu.vim')
vim.cmd('source ~/.config/vim/settings/undo_swap_backup.vim')

-- Plugin Manager
require('quitlox.lazy')

-- Environment Specific
-- These should be sourced first, as these files often contain work-arounds
-- to make the general configurations compatible.
for _, f in ipairs(vim.fn.glob('~/.config/vim/settings/environments/*.vim', false, true)) do
  vim.cmd('source ' .. f)
end

-- Plugin Configuration
for _, f in ipairs(vim.fn.glob('~/.config/vim/settings/plugins/shared/*.vim', false, true)) do
  vim.cmd('source ' .. f)
end

