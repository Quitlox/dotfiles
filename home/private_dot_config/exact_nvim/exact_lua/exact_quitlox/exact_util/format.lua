-- Credits LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/format.lua#L99

local M = {}

---@param buf? number
function M.enabled(buf)
    local gaf = vim.g.autoformat
    local baf = vim.b[buf].autoformat

    -- If the buffer has a local value, use that
    if baf ~= nil then
        return baf
    end

    -- Otherwise use the global value if set, or true by default
    return gaf == nil or gaf
end

return M
