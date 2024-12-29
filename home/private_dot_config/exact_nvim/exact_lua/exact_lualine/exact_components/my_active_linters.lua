---@module my_active_linters
---Returns the linters (using nvim-lint) that are currently running.

local M = require("lualine.component"):extend()

function M:init(options)
    M.super.init(self, options)
end

function M:update_status()
    local linters = require("lint").get_running()

    if #linters == 0 then
        return "󰦕 "
    end

    return "󱉶  " .. table.concat(linters, ", ")
end

return M
