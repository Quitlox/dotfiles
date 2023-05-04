----------------------------------------------------------------------
--                  Debug Adapter Protocol: Client                  --
----------------------------------------------------------------------
-- This scripts configures the nvim-dap plugin, which acts as a DAP client.

return {
    {
        "mfussenegger/nvim-dap",
        version = "",
        config = function()
            local dap = require("dap")

            -- Set log level
            dap.set_log_level("TRACE")

            -- Setup nvim-dap-vscode-js
            local path = require("quitlox.util.path")
            require("dap-vscode-js").setup({
                -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                debugger_path = path.concat({ vim.fn.stdpath("data"), "lazy", "vscode-js-debug" }), -- Path to vscode-js-debug installation.
                -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
            })

            for _, language in ipairs({ "typescript", "javascript" }) do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach:9229",
                        -- processId = require("dap.utils").pick_process,
                        -- protocol = "inspector",
                        -- port = 9229,
                        -- cwd = "${workspaceFolder}",
                        remoteRoot = "/app",
                        websocketAddress="ws://localhost:9229/00831fe4-8d99-4f36-b617-b4501a6f5447",
                        resolveSourceMapLocations = {
                            "${workspaceFolder}/**",
                            -- "/app/**",
                            "!**/node_modules/**",
                        },
                    },
                }
            end

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
            { "microsoft/vscode-js-debug", build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out", version = "v1.*" },
            "mxsdev/nvim-dap-vscode-js",
        },
    },
}
