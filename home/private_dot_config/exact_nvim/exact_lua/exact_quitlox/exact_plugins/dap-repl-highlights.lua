require("nvim-dap-repl-highlights").setup()

-- Install treesitter parser for dap_repl
local ok, res = pcall(vim.treesitter.language.inspect, "dap_repl")
if not ok then
    vim.notify("Installing dap_repl treesitter parser", vim.log.levels.INFO, { title = "nvim-dap-repl-highlights" })
    vim.cmd([[TSInstall dap_repl]])
    vim.notify("Parser installed", vim.log.levels.INFO, { title = "nvim-dap-repl-highlights" })
end
