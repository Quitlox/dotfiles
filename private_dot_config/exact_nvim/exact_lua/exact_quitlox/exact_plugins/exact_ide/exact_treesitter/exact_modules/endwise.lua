----------------------------------------------------------------------
--                       Treesitter: Endwise                        --
----------------------------------------------------------------------
-- Endwise (autopairs for lua)

return {
    "RRethy/nvim-treesitter-endwise",
    ft = "ruby,lua,vim,bash,elixir",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
