local M = {}

local conf = {}

M.on_save = function()
    local venv = require("venv-selector").venv()
    local source = require("venv-selector").source()
    return { path = venv, source = source }
end

M.on_post_load = function(data)
    if data == nil or data.path == nil then
        return
    end

    require("quitlox.util.python").deactivate()
    require("quitlox.util.python").activate_venv(data.path, data.source, nil)
end

return M
