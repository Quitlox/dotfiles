return {
    ---------- Improved Defaults ----------
    -- Matchup - Better %
    {
        "andymass/vim-matchup",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            vim.g.matchup_matchparen_enabled = 0
            require("nvim-treesitter.configs").setup({
                matchup = {
                    enable = true,
                },
            })
        end,
    },
    -- We use sentiment.nvim for highlighting instead of vim-matchup
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy",
        enabled = false,
        opts = {},
    },
    require("quitlox.util").legendary({
        { ":DoMatchParen", "Enable highlighting of matching parenthesis" },
        { ":NoMatchParen", "Disable highlighting of matching parenthesis" },
    }),
}
