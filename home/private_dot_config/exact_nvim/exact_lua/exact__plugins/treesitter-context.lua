-- +---------------------------------------------------------+
-- | nvim-treesitter-context: Show context at top of buffer  |
-- +---------------------------------------------------------+

require("treesitter-context").setup({
    enable = true,
    max_lines = 4,
    multiwindow = true,
    trim_scope = "inner", -- consider python multi-line function parameters
    on_attach = function(buf)
        -- Disable in diffview buffers to prevent scrollbind misalignment
        return not vim.b[buf].ts_context_disable
    end,
})
