-- Keymaps
vim.keymap.set("n", "<C-f>", function()
    require("spectre").open_visual({ select_word = true })
end, { desc = "Find & Replace" })
vim.keymap.set("v", "<C-f>", function()
    require("spectre").open_visual()
end, { desc = "Find & Replace" })

-- Command
require("legendary").command({
    ":ReplaceFile",
    function()
        require("spectre").open_file_search({ select_word = true })
    end,
    description = "Find & Replace in File",
})
