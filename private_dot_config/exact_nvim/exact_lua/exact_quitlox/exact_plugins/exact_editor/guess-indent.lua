return {
    {
        "nmac427/guess-indent.nvim",
        lazy = false,
        opts = {},
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = require("quitlox.util").legendary({
            { ":GuessIndent", description = "Guess indent" },
        }),
    },
}
