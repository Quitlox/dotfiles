-- +---------------------------------------------------------+
-- | chrisgrieser/nvim-origami: Folding                      |
-- +---------------------------------------------------------+

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

require("origami").setup({
    useLspFoldsWithTreesitterFallback = true,
    foldtext = {
        diagnosticsCount = true,
        gitsignsCount = true,
        disableOnFt = { "snacks_picker_input", "grug-far" },
    },
    autoFold = {
        enabled = false,
        kinds = { "comment", "imports" },
    },
    foldKeymaps = {
        setup = false, -- modifies `h`, `l`, and `$`
        hOnlyOpensOnFirstColumn = false,
    },
})
