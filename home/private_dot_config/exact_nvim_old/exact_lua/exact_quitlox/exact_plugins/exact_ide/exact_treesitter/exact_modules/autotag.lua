----------------------------------------------------------------------
--                       Treesitter: AutoTag                        --
----------------------------------------------------------------------
-- AutoTag (autopairs for html/jsx/etc)

return {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
}
