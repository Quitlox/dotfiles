-- +---------------------------------------------------------+
-- | iofq/dart.nvim: Bufferline                              |
-- +---------------------------------------------------------+

require("dart").setup({
    tabline = {
        always_show = false,
    },
    mappings = {
        mark = "Mm",
        jump = "M",
        pick = "Mp",
        next = "[b",
        prev = "]b",
        unmark_all = "Mu",
    },
})

vim.api.nvim_set_hl(0, "DartCurrent", { underline = false })
vim.api.nvim_set_hl(0, "DartCurrentLabel", { underline = false })
