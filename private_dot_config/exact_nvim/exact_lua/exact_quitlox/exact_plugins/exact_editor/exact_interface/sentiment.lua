return {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
    init = function()
        -- `matchparen.vim` needs to be disabled manually in case of lazy loading
        vim.g.loaded_matchparen = 1

        require("legendary").commands({
            { ":DoMatchParen", description = "Enable highlighting of matching parenthesis" },
            { ":NoMatchParen", description = "Disable highlighting of matching parenthesis" },
        })
    end,
}
