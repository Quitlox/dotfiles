----------------------------------------------------------------------
--                       Treesitter: Rainbow                        --
----------------------------------------------------------------------
-- Rainbow parenthesis (treesitter module)

return {
    "mrjones2014/nvim-ts-rainbow",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ----- Rainbow -----
            -- with: p00f/nvim-ts-rainbow
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = 20000,
                disable = { "latex" },
            },
        })
    end,
}
