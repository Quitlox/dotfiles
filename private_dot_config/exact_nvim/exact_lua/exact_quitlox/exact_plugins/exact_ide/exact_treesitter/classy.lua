return {
    {
        "dzfrias/nvim-classy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,
        config = true,
        opts = {
            auto_start = true,
        },
        name = "classy",
    },
    require("quitlox.util").legendary({
        { ":ClassyConceal", "Turn on concealing HTML attributes." },
        { ":ClassyUnconceal", "Turn off concealing HTML attributes." },
        { ":ClassyToggleConceal", "Toggles concealing HTML attributes for the individual class under the cursor." },
    }),
}
