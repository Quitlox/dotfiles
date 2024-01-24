return {
    {
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
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":IconPickerNormal alt_font symbols nerd_font_v3 emoji",
                description = "Open Icon Picker",
            })
        end,
    },
}
