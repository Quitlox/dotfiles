return {
    {
        "nvim-pack/nvim-spectre",
        keys = {
            -- stylua: ignore start
            { "<C-F>", function() require("spectre").open_visual({ select_word = true }) end, desc = "Find & Replace" },
            { "<C-F>", function() require("spectre").open_visual() end, desc = "Find & Replace", mode = { "v" } },
            -- stylua: ignore end
        },
    },
    require("quitlox.util").legendary_full({
        { ":Replace", 'lua require("spectre").open_visual({select_word=true})<CR>', description = "Find & Replace" },
        { ":ReplaceFile", 'lua require("spectre").open_file_search({select_word=true})<CR>', description = "Find & Replace (Current File)" },
    }),
}
