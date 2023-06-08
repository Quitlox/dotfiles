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
        require('legendary').command({
            ":HardWrapMode",
            description = "Toggle hard wrap mode",
        })
        require('legendary').command({
            ":SoftWrapMode",
            description = "Toggle soft wrap mode",
        })
        require('legendary').command({
            ":ToggleWrapMode",
            description = "Toggle wrap mode",
        })
    end,
}
