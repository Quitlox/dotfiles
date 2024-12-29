local M = require("lualine.component"):extend()

local function actived_venv()
    local venv_name = require("venv-selector").venv()
    if venv_name == nil then
        return ""
    end

    -- poetry: return the name
    if string.find(venv_name, "pypoetry") ~= nil then
        return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "poetry")
    end

    -- venv: return the last part of the path
    -- (if the venv is a directory in the form `.?venv`)
    local find_venv = string.find(venv_name, "./venv")
    local find_dot_venv = string.find(venv_name, "/.venv")
    if find_venv ~= nil then
        return string.sub(venv_name, find_venv[0], -1)
    end
    if find_dot_venv ~= nil then
        return string.sub(venv_name, find_dot_venv + 1, -1)
    end

    return venv_name
end

function M:update_status()
    if vim.bo.filetype ~= "python" then
        return ""
    end

    local venv = actived_venv()
    if venv == "" then
        return ""
    end

    return "(" .. venv .. ")"
end

return M
