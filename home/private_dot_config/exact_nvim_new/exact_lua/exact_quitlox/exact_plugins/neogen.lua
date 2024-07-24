-- +---------------------------------------------------------+
-- | danymat/neogen: Annotation Generator                    |
-- +---------------------------------------------------------+

require("neogen").setup({
    snippet_engine = "luasnip",
    languages = {
        python = {
            template = {
                annotation_convention = "reST",
            },
        },
    },
})

-- Keymaps
vim.keymap.set("n", "gca", function() require("neogen").generate({}) end, { noremap = true, silent = true, desc = "Generate Annotation" })
