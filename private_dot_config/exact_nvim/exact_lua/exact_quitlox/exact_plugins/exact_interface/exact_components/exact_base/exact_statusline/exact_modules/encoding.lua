----------------------------------------------------------------------
--                        [Module] Encoding                         --
----------------------------------------------------------------------
-- Don't display if encoding is UTF-8.

local encoding = function()
    local replaced, _count = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return replaced
end

return encoding
