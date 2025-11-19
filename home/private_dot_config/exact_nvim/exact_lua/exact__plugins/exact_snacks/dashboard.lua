-- +---------------------------------------------------------+
-- | snacks.nvim: Dashboard                                  |
-- +---------------------------------------------------------+

--+- Actions ------------------------------------------------+
local action_open_projects = function()
    Snacks.picker.projects(require("_plugins.snacks.picker").projects_dashboard)
end

local action_open_sessions = function()
    local sessions = require("resession").list()
    if #sessions == 0 then
        vim.notify("No sessions found", vim.log.levels.INFO)
        return
    end
    vim.ui.select(sessions, {
        prompt = "Select session:",
        format_item = function(session)
            return session
        end,
    }, function(session)
        if session then
            require("resession").load(session, { attach = true, reset = true })
        end
    end)
end

local action_open_session_last = function()
    require("resession").load("last", { silence_errors = true })
end

local action_open_config = function()
    local resession = require("resession")
    local util = require("_config.util.session")
    local config_dir = vim.fn.expand("~/.config/nvim")

    -- Save current session
    resession.save_tab(util.get_session_name(), { notify = false, attach = true })

    -- Navigate to config directory
    vim.cmd("tcd " .. vim.fn.fnameescape(config_dir))

    -- Load config session if it exists
    local config_session_name = util.get_session_name(config_dir)
    local resession_util = require("resession.util")
    local session_file = resession_util.get_session_file(config_session_name)
    local session_basename = vim.fs.basename(session_file)
    local final_session_name = session_basename:gsub("%.json$", "")

    if vim.tbl_contains(resession.list(), final_session_name) then
        resession.load(final_session_name, { attach = true, reset = true })
    else
        resession.detach()
        util.close_everything()
    end

    -- Open file picker in config directory
    Snacks.dashboard.pick("files", { cwd = config_dir })
end

--+- Wallpaper ----------------------------------------------+
local cmd_chafa = require("_config.util.chafa_cache").get_cached_terminal_cmd("chafa ~/Pictures/Wallpapers/dark_forest1.jpg --format symbols --symbols vhalf --size 60x17 --stretch")

vim.api.nvim_create_user_command("SnacksDashboardClearCache", function()
    require("_config.util.chafa_cache").clear_cache()
end, { desc = "Clear Snacks dashboard chafa cache" })

--+- Config -------------------------------------------------+
return {
    enabled = true,
    sections = {
        { section = "terminal", cmd = cmd_chafa, height = 17, padding = 1 },
        { pane = 2, { section = "keys", gap = 1, padding = 1 } },
    },
    preset = {
        keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "p", desc = "Project", action = action_open_projects },
            { icon = " ", key = "s", desc = "Select Session", action = action_open_sessions },
            { icon = " ", key = "l", desc = "Last Session", action = action_open_session_last },
            { icon = " ", key = "c", desc = "Config", action = action_open_config },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
    },
}
