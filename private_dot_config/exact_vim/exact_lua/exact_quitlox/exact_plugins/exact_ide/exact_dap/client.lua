----------------------------------------------------------------------
--                  Debug Adapter Protocol: Client                  --
----------------------------------------------------------------------
-- This scripts configures the nvim-dap plugin, which acts as a DAP client.

return {
    {
        "mfussenegger/nvim-dap",
        keys = "<localleader>d",
        config = function()
            local dap = require("dap")

            -- Set log level
            dap.set_log_level("TRACE")

            -- Configure launch.json file handling
            require("quitlox.plugins.ide.dap.include.launch_json")
        end,
        dependencies = {
            -- Persistent breakpoints
            {
                "Weissle/persistent-breakpoints.nvim",
                config = true,
                opts = {
                    load_breakpoints_event = { "BufReadPost" },
                },
            },
        },
    },
}
