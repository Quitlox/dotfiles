-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap: Debug Adapter Protocol           |
-- +---------------------------------------------------------+

local dap = require("dap")

-- dap.defaults.fallback
dap.defaults.fallback.switchbuf = "useopen,uselast"

--+- Launch.json --------------------------------------------+
-- Command: Reload launch.json
local function load_launch_json()
    local status, err = pcall(require("dap.ext.vscode").load_launchjs)
    if not status then
        require("notify")("Is there a typo in the config?\n\n" .. err, "ERROR", { title = "Error while loading .vscode/launch.json" })
    end
end

-- Load launch.json when edited
local launch_group = vim.api.nvim_create_augroup("LaunchJson", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = launch_group,
    desc = "Reload launch.json on save",
    pattern = "launch.json",
    callback = load_launch_json,
})

vim.api.nvim_create_user_command("LoadLaunchJson", load_launch_json, {
    desc = "Reload launch.json",
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<F9>", function() require("dap").continue() end, { noremap = true, silent = true, desc = "Debug Continue" })
vim.keymap.set("n", "<S-F9>", function() require("dap").goto_() end, { noremap = true, silent = true, desc = "Debug until Cursor" })
vim.keymap.set("n", "<F8>", function() require("dap").step_over() end, { noremap = true, silent = true, desc = "Debug Step Over" })
vim.keymap.set("n", "<S-F8>", function() require("dap").step_out() end, { noremap = true, silent = true, desc = "Debug Step Out" })
vim.keymap.set("n", "<F7>", function() require("dap").step_into() end, { noremap = true, silent = true, desc = "Debug Step Into" })

vim.keymap.set("n", "<leader>dd", function() require("dap").continue() end, { noremap = true, silent = true, desc = "Debugger Launch/Continue" })
vim.keymap.set("n", "<leader>dx", function() require("dap").terminate() end, { noremap = true, silent = true, desc = "Debugger Terminate" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapToggleRepl<cr>", { noremap = true, silent = true, desc = "Open REPL" })

vim.keymap.set("n", "<leader>dt", function() require("dap").toggle_breakpoint() end, { noremap = true, silent = true, desc = "Breakpoint Toggle" })
vim.keymap.set("n", "<leader>dbm", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { noremap = true, silent = true, desc = "Breakpoint Message" })
vim.keymap.set("n", "<leader>dbc", function() require("dap").toggle_breakpoint(vim.fn.input("Condition: ")) end, { noremap = true, silent = true, desc = "Breakpoint Condition" })

vim.keymap.set("n", "<leader>dv", "<cmd>LoadLaunchJson<cr>", { noremap = true, silent = true, desc = "Reload launch.json" })
-- stylua: ignore end

--+- DAP: Javascript / Typescript ---------------------------+
require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        ---@diagnostic disable-next-line: assign-type-mismatch
        args = { vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "vscode-js-debug"), "${port}" },
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
