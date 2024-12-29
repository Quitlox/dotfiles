---@module my_encoding
---Returns the file encoding of the current buffer, i.e. utf-8, latin1, etc.
---If the file encoding is utf-8 (default), it returns an empty string.

local M = require("lualine.component"):extend()

function M:init(options)
    M.super.init(self, options)
end

function M:update_status()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

return M
