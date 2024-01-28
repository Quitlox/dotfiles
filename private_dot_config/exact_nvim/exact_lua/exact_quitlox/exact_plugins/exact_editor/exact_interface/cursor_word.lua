----------------------------------------------------------------------
--                   Cursor Word: vim-illuminate                    --
----------------------------------------------------------------------
-- Hightlight all occurences of the word under the cursor

require("quitlox.util").on_attach(function(client, buffer) require("illuminate").on_attach(client) end, "Lazy load vim-illuminate.")

return {
    "RRethy/vim-illuminate",
    lazy = true,
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
