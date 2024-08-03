local path = require("quitlox.util.path")

require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        ---@diagnostic disable-next-line: assign-type-mismatch
        args = { path.concat({ vim.fn.stdpath("data"), "lazy", "vscode-js-debug" }), "${port}" },
    },
}

for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }
end

-- FIXME: To be able to use these configurations again, install the required dependencies.
-- See https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
-- { "microsoft/vscode-js-debug", build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git reset --hard HEAD", version = "v1.*" },
