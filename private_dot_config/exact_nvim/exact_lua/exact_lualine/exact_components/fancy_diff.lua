-- Copied from: https://github.com/meuter/lualine-so-fancy.nvim/blob/main/lua/lualine/components/fancy_diff.lua
local M = require("lualine.components.diff"):extend()

function M:update_status(is_focused)
    -- Custom code to use gitsigns
    local git_diff = vim.b.gitsigns_status_dict
    if git_diff == nil then
        -- If gitsigns is not available, fallback to the default diff
        git_diff = require("lualine.components.diff.git_diff").get_sign_count((not is_focused and vim.api.nvim_get_current_buf()))
        if git_diff == nil then
            return ""
        end
    else
        -- We need to convert the gitsigns status dict to the same format as the diff status dict
        git_diff = {
            added = git_diff.added,
            modified = git_diff.changed,
            removed = git_diff.removed,
        }
    end

    -- Original code from lualine
    local colors = {}
    if self.options.colored then
        -- load the highlights and store them in colors table
        for name, highlight_name in pairs(self.highlights) do
            colors[name] = self:format_hl(highlight_name)
        end
    end

    local result = {}
    -- loop though data and load available sections in result table
    for _, name in ipairs({ "added", "modified", "removed" }) do
        if git_diff[name] and git_diff[name] > 0 then
            if self.options.colored then
                table.insert(result, colors[name] .. self.options.symbols[name] .. git_diff[name])
            else
                table.insert(result, self.options.symbols[name] .. git_diff[name])
            end
        end
    end
    if #result > 0 then
        return table.concat(result, " ")
    else
        return ""
    end
end

function M:init(options)
    options.symbols = vim.tbl_extend("keep", options.symbols or {}, {
        added = " ",
        modified = " ",
        removed = " ",
    })
    M.super.init(self, options)
end

return M
