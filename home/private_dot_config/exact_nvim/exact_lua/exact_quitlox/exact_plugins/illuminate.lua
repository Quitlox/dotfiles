-- +---------------------------------------------------------+
-- | rrethy/vim-illuminate: Highlight word under cursor      |
-- +---------------------------------------------------------+

require("illuminate").configure({
    delay = 1000,
    filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
        "help",
    },
    under_cursor = false,
    large_file_cutoff = 5000,
    min_count_to_highlight = 3,
})
