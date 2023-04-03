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
        require("quitlox.util.which_key").register({
            T = {
                name = "Toggle",
                z = { "<cmd>ZenMode<cr>", "Toggle Zen Mode" },
            },
        }, { prefix = "<leader>" })
    end,
}
