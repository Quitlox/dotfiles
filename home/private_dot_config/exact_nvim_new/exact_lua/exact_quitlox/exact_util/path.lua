-- from: mason-core.path
local sep = (function()
    ---@diagnostic disable-next-line: undefined-global
    if jit then
        ---@diagnostic disable-next-line: undefined-global
        local os = string.lower(jit.os)
        if os == "linux" or os == "osx" or os == "bsd" then
            return "/"
        else
            return "\\"
        end
    else
        return package.config:sub(1, 1)
    end
end)()

local M = {}

-- from: mason-core.path
---@param path_components string[]
---@return string
function M.concat(path_components) return table.concat(path_components, sep) end

-- from mason-core.path
---@path root_path string
---@path path string
function M.is_subdirectory(root_path, path) return root_path == path or path:sub(1, #root_path + 1) == root_path .. sep end

-- from: https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
--- Check if a file or directory exists in this path
function M.exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

--- Check if a directory exists in this path
function M.isdir(path)
    -- "/" works on both Unix and Windows
    return exists(path .. "/")
end

return M
