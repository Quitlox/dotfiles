----------------------------------------------------------------------
--                   Neogen: Annotation Generator                   --
----------------------------------------------------------------------

return {
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
    config = true,
    cmd = { "Neogen" },
    init = function()
        require('legendary').command({
            ":Neogen",
            description = "Generate Annotation",
        })
        require('legendary').command({
            ":Neogen func",
            description = "Generate Function Annotation",
        })
        require('legendary').command({
            ":Neogen type",
            description = "Generate Type Annotation",
        })
        require('legendary').command({
            ":Neogen class",
            description = "Generate Class Annotation",
        })
    end,
}
