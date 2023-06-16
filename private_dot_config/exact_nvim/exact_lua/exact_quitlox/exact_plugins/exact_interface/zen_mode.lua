return {
    "folke/zen-mode.nvim",
    version = "",
    config = true,
    cmd = { "ZenMode" },
    dependencies = {
        "folke/twilight.nvim",
        opts = {
            dimming = {
                alpha = 0.5,
            },
            exclude = {},
        },
    },
    opts = {
        kitty = {
            enabled = true,
            font = "+2",
        },
    },
    init = function()
        require('legendary').command({
            ":ZenMode",
            description = "Toggle Zen Mode",
        })
    end,
}
