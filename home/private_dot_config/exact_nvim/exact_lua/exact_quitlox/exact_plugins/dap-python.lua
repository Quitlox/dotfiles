-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap-python: Python Debug Adapter      |
-- +---------------------------------------------------------+

-- Use available python interpreter (either venv or system python)
require("dap-python").setup("python", { include_configs = true })
-- Set pytest as default test runner
require("dap-python").rest_runner = "pytest"

-- On Python filetype, switch stepping_granularity
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyDapPythonDefaults", { clear = true }),
    callback = function(args)
        local filetype = args.event

        if filetype and filetype ~= "python" then
            -- The default is statement
            require("dap").defaults.fallback.stepping_granularity = "statement"
        else
            require("dap").defaults.fallback.stepping_granularity = "line"
        end
    end,
})
