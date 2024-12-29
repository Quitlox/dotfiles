-- This is a small wrapper around pretty_path that always pads the icon.

local M = require("lualine.components.pretty_path"):extend()

-- Always pad the icon
local icon_padding = {
    [""] = 0,
    [""] = 0,
    ["󰏇"] = 0,
}
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

    self.options.use_color = true
    self.options.icon_padding = icon_padding

    self.options.symbols = {
        modified = "", -- somewhat redundant if using modified highlight
        readonly = " ",
        newfile = "", -- somewhat redundant if using newfile highlight
        ellipsis = "..", -- used between shortened directory parts
    }

    self.options.custom_icons = {
        gitrebase = { " ", "DevIconGitCommit" },
        help = { " ", "DevIconTxt" },
        oil = { "󰏇 ", "OilDir" },
        trouble = { " ", "DevIconGitConfig" },
        Trouble = { " ", "DevIconGitConfig" },
    }
end

return M
