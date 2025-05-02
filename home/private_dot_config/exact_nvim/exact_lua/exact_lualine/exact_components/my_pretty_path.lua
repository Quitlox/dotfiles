-- This is a small wrapper around pretty_path that always pads the icon.

local M = require("lualine.components.pretty_path"):extend()

-- Always pad the icon
local icon_padding = {}
setmetatable(icon_padding, {
    __index = function(table, key)
        local value = rawget(table, key)
        if value ~= nil then
            return value
        end

        return 1
    end,
})

function M:init(options)
    M.super.init(self, options)

    self.options.icon_show_inactive = true
    self.options.use_color = true
    self.options.icon_padding = icon_padding

    self.options.symbols = {
        modified = "", -- somewhat redundant if using modified highlight
        readonly = " ",
        newfile = "", -- somewhat redundant if using newfile highlight
        ellipsis = "..", -- used between shortened directory parts
    }

    self.options.custom_icons = {
        gitrebase = { "", "DevIconGitCommit" },
        help = { "", "DevIconTxt" },
        oil = { "󰏇", "OilDir" },
        trouble = { "", "DevIconGitConfig" },
        Trouble = { "", "DevIconGitConfig" },
        -- codecompanion = { "✨", "DevIconGitConfig" },
    }
end

--- I am overriding the update_status function to fix a bug with
--- `vim.fn.expand` returning nil. If I find the edge-case in which this
--- happens, I should report it upstream.
function M:update_status(is_focused)
    self.is_focused = is_focused

    -- Get path and ensure it's never nil
    local path = vim.fn.expand(self.options.use_absolute and "%:p" or "%:~:.")

    if path == nil then
        vim.notify('vim.fn.expand("%:~:.") returned nil. Current cwd: ' .. vim.fn.getcwd(), vim.log.levels.ERROR)
        path = "" -- This is the key fix - ensure path is never nil
    end

    -- Early return with empty string for problematic cases
    -- This avoids the nil indexing error in the provider
    if path == "" then
        self.options.icon = nil
        return ""
    end

    local provider = self:get_provider(path)
    local hl_fn = function(text, group)
        return self:_hl(text, group)
    end

    -- Catch any errors during provider initialization
    local ok, p = pcall(function()
        return provider:new(path, is_focused, hl_fn, self.options)
    end)

    if not ok then
        self.options.icon = nil
        return ""
    end

    if not self.options.icon_show or not (self.is_focused or self.options.icon_show_inactive) or not p.icon[1] then
        self.options.icon = nil
    else
        local icon = p.icon[1]
        local padding = self.options.icon_padding[icon] or 0
        self.options.icon = self:_hl(icon .. string.rep(" ", padding), p.icon[2])
    end

    -- Safely render the path
    local ok2, result = pcall(function()
        return p:render()
    end)

    return ok2 and result or ""
end

return M
