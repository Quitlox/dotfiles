local M = require("lualine.component"):extend()

function M:init(options)
    options.icon = options.icon or { " ", color = {} }
    M.super.init(self, options)
end

function M:update_status()
    -- Add pcall to catch any error from searchcount()
    local success, search = pcall(function()
        return vim.fn.searchcount({ maxcount = 0 })
    end)

    -- Only proceed if the call was successful
    if success and search and next(search) ~= nil then
        if search.current > 0 and vim.v.hlsearch ~= 0 then
            return search.current .. "/" .. search.total
        end
    end

    -- Return empty string if there was an error or no valid search
    return ""
end

return M
