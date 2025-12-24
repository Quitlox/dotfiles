local M = {}

--- Helper function to check if a module is available
---@param module string The module name to check
---@return boolean Whether the module is available
local function has_module(module)
    return package.loaded[module] ~= nil or pcall(require, module)
end

--- Called when saving a session to capture python.nvim state
---@param opts? table Session save options
---@return table python_data The python.nvim state data to save
M.on_save = function(opts)
    return {} -- Nothing to save, python.nvim manages its own state
end

--- Called before loading a session to restore python.nvim venv
M.on_pre_load = function(data)
    if not has_module("python") then
        return
    end
    -- Activate venv from state before buffers are restored
    -- This ensures PATH and VIRTUAL_ENV are set before LSP tries to start
    require("python.venv.detect").detect_venv_dependency_file(false, true)
end

--- Called after loading a session to ensure commands are available
M.on_post_load = function(data)
    if not has_module("python") then
        return
    end
    -- Load commands for current buffer if it's a Python file
    -- This is needed because BufEnter doesn't fire for the restored active buffer
    if vim.bo.filetype == "python" then
        require("python.commands").load_commands()
        require("python.venv").load_existing_venv()
    end
end

return M
