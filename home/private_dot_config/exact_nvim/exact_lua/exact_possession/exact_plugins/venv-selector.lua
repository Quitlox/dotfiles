-- NOTE: Possession doesn't actually support custom plugins yet, so this is loaded manually in my config.

local M = {}

function M.before_save(opts, name)
    local venv = require("venv-selector").venv()
    local source = require("venv-selector").source()
    return { path = venv, source = source }
end

function M.after_save(opts, name, plugin_data) end

function M.before_load(opts, name) end

function M.after_load(opts, name, plugin_data)
    if plugin_data == nil or plugin_data.path == nil then
        return
    end

    require("quitlox.util.python").deactivate()
    require("quitlox.util.python").activate_venv(plugin_data.path, plugin_data.source, nil)
end

return M
