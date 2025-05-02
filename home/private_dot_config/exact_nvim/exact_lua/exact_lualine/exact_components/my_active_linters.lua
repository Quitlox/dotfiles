---@module my_active_linters
---Returns the linters (using nvim-lint) that are currently running.

local M = require("lualine.component"):extend()

function M:init(options)
    M.super.init(self, options)
end

function M:update_status()
    local lint = require("lint")
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo.filetype

    -- Get registered linters for current filetype
    local registered_linters = lint.linters_by_ft[ft] or {}

    -- If no linters are registered for this filetype, don't show the component
    if #registered_linters == 0 then
        return ""
    end

    -- Get running linters for current buffer
    local running_linters = lint.get_running(bufnr)

    -- Filter running linters to only those registered for this filetype
    local filtered_running = {}
    for _, running in ipairs(running_linters) do
        for _, registered in ipairs(registered_linters) do
            if running == registered then
                table.insert(filtered_running, running)
                break
            end
        end
    end

    -- Show running count and total registered count
    return string.format("󱉶 %d (%d)", #filtered_running, #registered_linters)
end

return M
