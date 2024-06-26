return {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
        vim.g.copilot_filetypes = { Telescope = false, octo = false }
        vim.g.copilot_no_tab_map = true
    end,
    config = function()
        vim.cmd([[imap <silent><script><expr> <c-a> copilot#Accept("")]])
    end,
}
