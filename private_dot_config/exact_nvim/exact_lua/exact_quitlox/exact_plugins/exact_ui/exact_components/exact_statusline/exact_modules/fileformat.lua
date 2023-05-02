----------------------------------------------------------------------
--                       [Module] Fileformat                        --
----------------------------------------------------------------------
-- Don't display if the current fileformat is unix (i.e. 'default').

local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

return fileformat
