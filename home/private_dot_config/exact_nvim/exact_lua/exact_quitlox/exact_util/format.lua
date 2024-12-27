-- Credits LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/format.lua#L99

local M = {}

---@param buf? number
function M.enabled(buf)
    local gaf = vim.g.autoformat
    local baf = buf and vim.b[buf].autoformat or nil

    -- If the buffer has a local value, use that
    if baf ~= nil then
        return baf
    end

    -- Otherwise use the global value if set, or true by default
    return gaf == nil or gaf
end

---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
    if enable == nil then
        enable = true
    end
    if buf then
        vim.b.autoformat = enable
    else
        vim.g.autoformat = enable
        vim.b.autoformat = nil
    end
end

return M
