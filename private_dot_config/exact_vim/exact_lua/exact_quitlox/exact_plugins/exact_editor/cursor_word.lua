----------------------------------------------------------------------
--                   Cursor Word: vim-illuminate                    --
----------------------------------------------------------------------
-- Hightlight all occurences of the word under the cursor

return {
    "RRethy/vim-illuminate",
    config = function()
        require("illuminate").configure({
            delay = 1000,
            filetypes_denylist = {
                "dirvish",
                "fugitive",
                "nerdtree",
                "NvimTree",
            },
            under_cursor = true,
            large_file_cutoff = 10000,
        })
    end,
}
