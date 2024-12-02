-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap-python: Python Debug Adapter      |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "python",
    once = true,
    callback = function()
        local pythondap = require("dap-python")

        -- Use available python interpreter (either venv or system python)
        pythondap.setup("python")
        -- Set pytest as default test runner
        pythondap.rest_runner = "pytest"
    end,
})
