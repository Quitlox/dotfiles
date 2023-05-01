return {
    "ziontee113/icon-picker.nvim",
    config=true,
    opts = {
        disable_legacy_commands = true,
    },
    cmd = {
        "IconPickerNormal",
        "IconPickerInsert",
        "IconPickerYank",
    },
    init = function()
        require("which-key").register({
            i = { "<cmd>IconPickerNormal alt_font symbols nerd_font emoji<cr>", "Icon Picker" },
        }, { prefix = "<leader>" })
    end,
}
