-- NOTE: Possession doesn't actually support custom plugins yet, so this is loaded manually in my config.

local M = {}

function M.before_save(opts, name)
    local venv = require("venv-selector").venv()
    local source = require("venv-selector").source()
    return { path = venv, source = source }
end

function M.after_save(opts, name, plugin_data) end

function M.before_load(opts, name) require("quitlox.util.python").deactivate() end

function M.after_load(opts, name, plugin_data)
    if plugin_data and plugin_data.path then require("quitlox.util.python").activate_venv(plugin_data.path, plugin_data.source, nil) end
end

return M
