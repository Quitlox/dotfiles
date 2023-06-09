return {
    "ziontee113/icon-picker.nvim",
    config = true,
    opts = {
        disable_legacy_commands = true,
    },
    cmd = {
        "IconPickerNormal",
        "IconPickerInsert",
        "IconPickerYank",
    },
    init = function()
        require("legendary").command({
            ":IconPickerNormal alt_font symbols nerd_font emoji",
            description = "Open Icon Picker",
        })
    end,
}
