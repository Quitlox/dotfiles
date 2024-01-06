return {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    opts = {},
    enabled = false,
    init = function()
        vim.cmd [[command! -nargs=0 SymbolUsageToggle lua require('symbol-usage').toggle_globally()]]
    end,
}
