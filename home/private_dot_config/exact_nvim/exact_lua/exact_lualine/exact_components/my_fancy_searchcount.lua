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

-- NOTE: Throws error:
-- Error executing vim.schedule lua callback: ...l/share/nvim/rocks/rocks_rtp/lua/lualine/utils/utils.lua:211: lualine: Failed to refresh statusline:
-- ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:396: Error executing lua: Vim:E871: (NFA regexp) Can't have a multi follow a multi
-- stack traceback:
--         [C]: in function 'searchcount'
--         ...fig/nvim/lua/lualine/components/my_fancy_searchcount.lua:9: in function 'update_status'
--         ...cal/share/nvim/rocks/rocks_rtp/lua/lualine/component.lua:273: in function 'draw'
--         ...share/nvim/rocks/rocks_rtp/lua/lualine/utils/section.lua:26: in function 'draw_section'
--         ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:167: in function 'statusline'
--         ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:295: in function <...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:276>
--         [C]: in function 'nvim_win_call'
--         ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:396: in function 'refresh'
--         ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:472: in function <...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:471>
--         [C]: in function 'pcall'
--         ...l/share/nvim/rocks/rocks_rtp/lua/lualine/utils/utils.lua:214: in function ''
--         vim/_editor.lua: in function <vim/_editor.lua:0>
-- stack traceback:
--         [C]: in function 'error'
--         ...l/share/nvim/rocks/rocks_rtp/lua/lualine/utils/utils.lua:211: in function ''
--         vim/_editor.lua: in function <vim/_editor.lua:0>

return M
