----------------------------------------------------------------------
--                   Neogen: Annotation Generator                   --
----------------------------------------------------------------------

return {
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
            languages = {
                python = {
                    template = {
                        annotation_convention = "reST",
                    },
                },
            },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
        cmd = { "Neogen" },
    },
    require("quitlox.util").legendary({
        { ":Neogen", "Generate Annotation" },
        { ":Neogen func", "Generate Function Annotation" },
        { ":Neogen type", "Generate Type Annotation" },
        { ":Neogen class", "Generate Class Annotation" },
    }),
}
