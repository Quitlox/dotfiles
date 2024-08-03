-- +---------------------------------------------------------+
-- | github/copilot.vim: Copilot                             |
-- +---------------------------------------------------------+

vim.g.copilot_filetypes = { Telescope = false, octo = false }
vim.g.copilot_no_tab_map = true
vim.cmd([[imap <silent><script><expr> <c-a> copilot#Accept("")]])
