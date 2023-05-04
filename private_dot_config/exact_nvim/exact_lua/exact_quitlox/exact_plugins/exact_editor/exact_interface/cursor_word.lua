----------------------------------------------------------------------
--                   Cursor Word: vim-illuminate                    --
----------------------------------------------------------------------
-- Hightlight all occurences of the word under the cursor

return {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
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
    end,
}
