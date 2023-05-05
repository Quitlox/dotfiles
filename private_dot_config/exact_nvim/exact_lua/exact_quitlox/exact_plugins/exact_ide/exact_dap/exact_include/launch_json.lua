----------------------------------------------------------------------
--                         DAP: Launch.json                         --
----------------------------------------------------------------------
-- This script enables and configures the use of the launch.json file 
-- to configure debug configurations.

-- Command: Reload launch.json
local function load_launch_json()
    local status, err = pcall(require("dap.ext.vscode").load_launchjs)
    if not status then
        require("notify")(
            "Is there a typo in the config?\n\n" .. err,
            "ERROR",
            { title = "Error while loading .vscode/launch.json" }
        )
    end
end

-- Load launch.json on startup
load_launch_json()
-- Load launch.json when edited
local launch_group = vim.api.nvim_create_augroup("LaunchJson", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = launch_group,
    desc = "Reload launch.json on save",
    pattern = "launch.json",
    callback = load_launch_json,
})
-- Load launch.json via keybinding
require("which-key").register({
    name = "Debug",
    v = { load_launch_json, "Reload launch.json" },
}, { prefix = "<localleader>d" })
