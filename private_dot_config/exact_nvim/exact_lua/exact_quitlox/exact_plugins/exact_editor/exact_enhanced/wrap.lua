return {
    "andrewferrier/wrapping.nvim",
    config = true,
    opts = {
        auto_set_mode_filetype_allowlist = {
            "asciidoc",
            "gitcommit",
            "mail",
            "markdown",
            "rst",
            "tex",
            "text",
        },
    },
    init = function()
        require("legendary").commands({
            {
                ":HardWrapMode",
                description = "Toggle hard wrap mode",
            },
            {
                ":SoftWrapMode",
                description = "Toggle soft wrap mode",
            },
            {
                ":ToggleWrapMode",
                description = "Toggle wrap mode",
            },
        })
    end,
}
