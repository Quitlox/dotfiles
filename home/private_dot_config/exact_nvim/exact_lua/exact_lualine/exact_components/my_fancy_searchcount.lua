local M = require("lualine.component"):extend()

function M:init(options)
    options.icon = options.icon or { " ", color = {} }
    M.super.init(self, options)
end

function M:update_status()
    local search = vim.fn.searchcount({ maxcount = 0 })
    if next(search) ~= nil then
        if search.current > 0 and vim.v.hlsearch ~= 0 then
            return search.current .. "/" .. search.total
        end
    end
end

return M
