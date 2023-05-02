----------------------------------------------------------------------
--                        [Module] Filename                         --
----------------------------------------------------------------------

local filename = {
    "filename",
    path = 0,
    cond = function() return vim.bo.filetype ~= "NvimTree" end,
    symbols = {
        modified = "",
        readonly = "",
        unnamed = "",
        newfile = "",
    },
}

return filename
