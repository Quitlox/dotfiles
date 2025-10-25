-- +---------------------------------------------------------+
-- | LiadOz/nvim-dap-repl-highlights: Syntax highlighting    |
-- | for nvim-dap REPL buffer                                |
-- +---------------------------------------------------------+
-- TODO: this plugin may not be necessary with nvim-dap-view

require("nvim-dap-repl-highlights").setup()

-- Install treesitter parser for dap_repl
vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("MyInstallDapReplHighlights", { clear = true }),
    once = true,
    callback = function()
        local ok, err = pcall(vim.treesitter.language.inspect, "dap_repl")
        if not ok then
            vim.notify("Installing dap_repl treesitter parser", vim.log.levels.INFO, { title = "nvim-dap-repl-highlights" })
            vim.cmd([[TSInstall dap_repl]])
            vim.notify("Parser installed", vim.log.levels.INFO, { title = "nvim-dap-repl-highlights" })
        end
    end,
})
