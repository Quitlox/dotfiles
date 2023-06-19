----------------------------------------------------------------------
--                       Treesitter: AutoTag                        --
----------------------------------------------------------------------
-- AutoTag (autopairs for html/jsx/etc)

return {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ----- AutoTag -----
            -- The autopairs for languages like html
            autotag = {
                enable = true,
            },
        })
    end,
}
