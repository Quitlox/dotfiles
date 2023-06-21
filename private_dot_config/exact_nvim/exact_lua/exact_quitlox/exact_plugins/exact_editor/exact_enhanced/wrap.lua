local filetypes = {
    "asciidoc",
    "gitcommit",
    "mail",
    "markdown",
    "rst",
    "tex",
    "text",
}

return {
    {
        "andrewferrier/wrapping.nvim",
        config = true,
        ft = filetypes,
        opts = {
            create_keymappings = false,
            auto_set_mode_filetype_allowlist = filetypes,
        },
    },
    {
        {
            "mrjones2014/legendary.nvim",
            optional = true,
            opts = function(_, opts)
                opts.commands = opts.commands or {}
                table.insert(opts.commands, {
                    ":HardWrapMode",
                    description = "Toggle hard wrap mode",
                })
                table.insert(opts.commands, {
                    ":SoftWrapMode",
                    description = "Toggle soft wrap mode",
                })
                table.insert(opts.commands, {
                    ":ToggleWrapMode",
                    description = "Toggle wrap mode",
                })
            end,
        },
    },
}
