-- +---------------------------------------------------------+
-- | ziontee133/icon-picker.nvim: Icon Picker                |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
local function setup_icon_picker()
    require("icon-picker").setup({
        disable_legacy_commands = true,
    })
end

require("quitlox.util.lazy").command_stub_args("IconPickerNormal", setup_icon_picker)
require("quitlox.util.lazy").command_stub_args("IconPickerInsert", setup_icon_picker)
require("quitlox.util.lazy").command_stub_args("IconPickerYank", setup_icon_picker)

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":IconPickerNormal alt_font symbols nerd_font_v3 emoji", description = "Open Icon Picker" },
    { ":IconPickerYank alt_font symbols nerd_font_v3 emoji", description = "Open Icon Picker (Yank)" },
})
