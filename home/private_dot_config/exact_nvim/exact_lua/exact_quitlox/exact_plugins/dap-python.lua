-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap-python: Python Debug Adapter      |
-- +---------------------------------------------------------+

-- Use available python interpreter (either venv or system python)
require("dap-python").setup("python")
-- Set pytest as default test runner
require("dap-python").rest_runner = "pytest"
