----------------------------------------------------------------------
--                       Treesitter: Endwise                        --
----------------------------------------------------------------------
-- Endwise (autopairs for lua)
-- TODO: Add all relevant filetypes

return {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "ruby,lua,vim,bash,elixir",
    config = function()
        require("nvim-treesitter.configs").setup({
            ----- Endwise -----
            -- The autopairs for languages like lua (i.e. using 'end')
            endwise = {
                enable = true,
            },
        })
    end,
}
