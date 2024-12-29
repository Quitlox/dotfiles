---@module my_fileformat
---Returns the file format of the current buffer, i.e. unix, dos, or mac.
---If the file format is unix (default), it returns an empty string.

local M = require("lualine.component"):extend()

function M:init(options)
    M.super.init(self, options)
end

function M:update_status()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

return M
