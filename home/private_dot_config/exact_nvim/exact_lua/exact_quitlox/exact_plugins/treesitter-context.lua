-- +---------------------------------------------------------+
-- | nvim-treesitter-context: Show context at top of buffer  |
-- +---------------------------------------------------------+

require("treesitter-context").setup({
    max_lines = 4,
    multiwindow = true,
    trim_scope = "inner", -- consider python multi-line function parameters
})
