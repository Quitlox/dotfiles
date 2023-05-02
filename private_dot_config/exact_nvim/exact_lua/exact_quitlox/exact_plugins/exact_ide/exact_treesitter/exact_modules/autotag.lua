----------------------------------------------------------------------
--                       Treesitter: AutoTag                        --
----------------------------------------------------------------------
-- AutoTag (autopairs for html/jsx/etc)
-- TODO: Add all relevant filetypes

return {
    "windwp/nvim-ts-autotag",
    ft = "html,tsx,vue,svelte,php,rescript",
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
