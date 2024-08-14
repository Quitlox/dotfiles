local M = require("lualine.component"):extend()

local function actived_venv()
    local venv_name = require("venv-selector").venv()
    if venv_name ~= nil then
        if string.find(venv_name, "pypoetry") ~= nil then return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "poetry") end

        local find_venv = string.find(venv_name, "./venv")
        local find_dot_venv = string.find(venv_name, "/.venv")
        if find_venv ~= nil then return string.sub(venv_name, find_venv[0], -1) end
        if find_dot_venv ~= nil then return string.sub(venv_name, find_dot_venv + 1, -1) end

        return venv_name
    end

    return "none"
end

function M:init(options)
    options.separator = { left = "" }
    M.super.init(self, options)
end

function M:update_status()
    if vim.bo.filetype ~= "python" then return "" end
    return "(" .. actived_venv() .. ")"
end

return M
