return {
    {
        "nvim-pack/nvim-spectre",
        keys = {
            { "<C-F>", function() require("spectre").open_visual({ select_word = true }) end, desc = "Find & Replace" },
            {
                "<C-F>",
                function() require("spectre").open_visual() end,
                desc = "Find & Replace",
                mode = { "v" },
            },
        },
    },
    require("quitlox.util").legendary_full({
        { ":ReplaceFile", 'lua require("spectre").open_file_search({select_word=true})<CR>', description = "Find & Replace in file" },
    }),
}
