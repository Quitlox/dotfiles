---@module my_cwd
---Returns the last directory of the current working directory.

local M = require("lualine.component"):extend()
local trunc = require("quitlox.util.lualine").trunc

function M:init(options)
    options.icon = options.icon or " "
    options.fmt = trunc(160, 30, nil, false)
    M.super.init(self, options)
end

function M:update_status()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

return M
