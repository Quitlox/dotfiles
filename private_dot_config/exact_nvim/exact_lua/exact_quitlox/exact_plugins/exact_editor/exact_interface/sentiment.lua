return {
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    require("quitlox.util").legendary({
        { ":DoMatchParen", "Enable highlighting of matching parenthesis" },
        { ":NoMatchParen", "Disable highlighting of matching parenthesis" },
    }),
}
