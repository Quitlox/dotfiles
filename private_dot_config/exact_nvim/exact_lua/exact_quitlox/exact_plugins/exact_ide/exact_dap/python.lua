----------------------------------------------------------------------
--                           DAP: Python                            --
----------------------------------------------------------------------
-- This file contains the lazy.nvim plugin spec for the nvim-dap-python
-- plugin, which is a wrapper around the debugpy Python debugger.

return {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
        local path = require("quitlox.util.path")
        local pythondap = require("dap-python")

        local debugpy_path =
            path.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" })

        if path.exists(debugpy_path) then
            -- Setup Python DAP and point to debugpy
            pythondap.setup(debugpy_path)
            -- Set pytest as default test runner
            pythondap.rest_runner = "pytest"

            -- Set keymaps specifically for python
            require("which-key").register({
                x = { pythondap.test_class, "Debug Class" },
                y = { pythondap.test_method, "Debug Method" },
            }, { prefix = "<localleader>d" })
            require("which-key").register({
                s = { pythondap.debug_selection, "Debug Selection" },
            }, { prefix = "<localleader>d", mode = "v" })
        else
            require("notify")(
                'For Python debugging, install debugpy using: ":MasonInstall debugpy"',
                "WARN",
                { title = "No Python Debugging", timeout = 3000 }
            )
        end
    end,
}
