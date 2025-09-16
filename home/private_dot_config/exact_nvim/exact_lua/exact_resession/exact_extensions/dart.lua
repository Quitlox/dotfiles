local M = {}

--- Helper function to check if a module is available
---@param module string The module name to check
---@return boolean Whether the module is available
local function has_module(module)
    return package.loaded[module] ~= nil or pcall(require, module)
end

local get_session_name = require("quitlox.util.session").get_session_name

--- Called when saving a session to capture dart.nvim state
---@param opts? table Session save options
---@return table? dart_data The dart.nvim state data to save
M.on_save = function(opts)
    if not has_module("dart") then
        return {}
    end

    Dart.write_session(get_session_name())
    return {}
end

--- Called before loading a session to restore dart.nvim state
M.on_post_load = function(data)
    if not has_module("dart") then
        return
    end

    Dart.read_session(get_session_name())
end

return M
