-- +---------------------------------------------------------+
-- | github/copilot.vim: Copilot                             |
-- +---------------------------------------------------------+

vim.g.copilot_enabled = false
vim.g.copilot_filetypes = { Telescope = false, octo = false, tex = false, latex = false }
vim.g.copilot_no_tab_map = true
vim.cmd([[imap <silent><script><expr> <c-a> copilot#Accept("")]])
vim.cmd([[imap <silent><script><expr> <c-e> copilot#Accept("")]])

Snacks.toggle
    .new({
        name = "Copilot",
        get = function()
            local copilot_enabled = vim.g.copilot_enabled ~= 0 and vim.g.copilot_enabled ~= false
            return copilot_enabled
        end,
        set = function(state)
            if state then
                pcall(vim.cmd, "Copilot enable")
            else
                pcall(vim.cmd, "Copilot disable")
            end
        end,
    })
    :map("yoa")
