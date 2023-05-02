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
        require("which-key").register({
            name = "Generate",
            a = { "<cmd>Neogen<cr>", "Generate Annotation" },
            f = { "<cmd>Neogen func<cr>", "Generate Function annotation" },
            t = { "<cmd>Neogen type<cr>", "Comment Type annotation" },
            c = { "<cmd>Neogen class<cr>", "Comment Class annotation" },
        }, { prefix = "<leader>G" })
    end,
}
