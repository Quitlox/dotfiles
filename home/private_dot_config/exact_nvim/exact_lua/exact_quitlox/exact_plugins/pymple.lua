-- +---------------------------------------------------------+
-- | alexpasmantier/pymple.nvim: Refactor Python Imports     |
-- +---------------------------------------------------------+

require("pymple").setup({
    logging = {
        level = "trace",
    },
    keymaps = {
        resolve_import_under_cursor = {
            desc = "Resolve import under cursor",
            keys = "<leader><leader>pi",
        },
    },
})

require("which-key").add({
    { "<leader><leader>p", group = "Python" },
})
