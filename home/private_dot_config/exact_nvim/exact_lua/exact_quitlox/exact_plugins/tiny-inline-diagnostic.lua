-- +---------------------------------------------------------+
-- | rachartier/tiny-inline-diagnostic.nvim                  |
-- +---------------------------------------------------------+

require("tiny-inline-diagnostic").setup({
    preset = "modern",
    show_source = true,
    use_icons_from_diagnostic = true,
    multiple_diag_under_cursor = true,
})
