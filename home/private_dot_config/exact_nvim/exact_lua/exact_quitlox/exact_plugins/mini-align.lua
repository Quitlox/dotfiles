-- +---------------------------------------------------------+
-- | mini.align: Align using the 'ga' operator               |
-- +---------------------------------------------------------+

require("mini.align").setup({
    mappings = {
        start = "",
        start_with_preview = "g=",
    },
})

require("which-key").add({
    { "g=", desc = "Align" },
})
