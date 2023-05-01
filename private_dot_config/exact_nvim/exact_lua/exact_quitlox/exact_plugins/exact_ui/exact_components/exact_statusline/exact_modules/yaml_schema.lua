----------------------------------------------------------------------
--                       [Module] YAML Schema                       --
----------------------------------------------------------------------
-- Additionally to the filetype, show the schema that is currently being used
-- for auto-completion.

local function yaml_schema()
    -- Only show the schema if the current buffer is a yaml file
    if vim.bo.filetype ~= "yaml" then return "" end

    -- Import yaml-companion
    local yaml = require('yaml-companion')

    local schema = yaml.get_buf_schema(0)
    if schema then return schema.result[1].name end
    return ""
end

return yaml_schema
