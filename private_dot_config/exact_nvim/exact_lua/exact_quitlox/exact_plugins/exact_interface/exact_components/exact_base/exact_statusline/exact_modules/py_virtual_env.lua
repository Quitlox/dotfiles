local actived_venv = function()
  local venv_name = require('venv-selector').get_active_venv()
  if venv_name ~= nil then
    return string.gsub(venv_name, '.*/pypoetry/virtualenvs/', '(poetry) ')
  else
    return 'venv'
  end
end

local function virtual_env_text()
    return "  " .. actived_venv()
end

return virtual_env_text
