-- +---------------------------------------------------------+
-- | alexpasmantier/pymple.nvim: Refactor Python Imports     |
-- +---------------------------------------------------------+

require("legendary").commands({
    { ":PympleLogs", description = "Show Pymple Logs" },
})

require("pymple").setup({
    keymaps = {
        resolve_import_under_cursor = {
            desc = "Resolve import under cursor",
            keys = "<leader><leader>pi",
        },
    },
})
