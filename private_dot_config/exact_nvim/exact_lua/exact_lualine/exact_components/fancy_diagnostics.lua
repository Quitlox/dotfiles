-- Copied from: https://github.com/meuter/lualine-so-fancy.nvim/blob/main/lua/lualine/components/fancy_diagnostics.lua
local M = require("lualine.components.diagnostics"):extend()

function M:init(options)
    options.symbols = vim.tbl_extend("keep", options.symbols or {}, {
        error = " ",
        warn = " ",
        hint = " ",
        info = " ",
    })
    M.super.init(self, options)
end

return M
