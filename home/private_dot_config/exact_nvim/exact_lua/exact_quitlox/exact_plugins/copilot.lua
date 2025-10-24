-- +---------------------------------------------------------+
-- | github/copilot.vim: Copilot                             |
-- +---------------------------------------------------------+

vim.g.copilot_enabled = true
vim.g.copilot_filetypes = { Telescope = false, octo = false, tex = false, latex = false }
vim.g.copilot_no_tab_map = true
vim.cmd([[imap <silent><script><expr> <c-a> copilot#Accept("")]])
vim.cmd([[imap <silent><script><expr> <c-e> copilot#Accept("")]])
