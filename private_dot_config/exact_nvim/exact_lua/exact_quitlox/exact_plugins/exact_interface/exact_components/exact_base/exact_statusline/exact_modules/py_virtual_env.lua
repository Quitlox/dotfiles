local actived_venv = function()
    local venv_name = require("venv-selector").get_active_venv()
    if venv_name ~= nil then
        if string.find(venv_name, "pypoetry") ~= nil then return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "poetry") end

        local find_venv = string.find(venv_name, "./venv")
        local find_dot_venv = string.find(venv_name, "/.venv")
        if find_venv ~= nil then return string.sub(venv_name, find_venv[0], -1) end
        if find_dot_venv ~= nil then return string.sub(venv_name, find_dot_venv + 1, -1) end

        return venv_name
    else
        return "venv"
    end
end

local function virtual_env_text() return " (" .. actived_venv() .. ") " end

return virtual_env_text
