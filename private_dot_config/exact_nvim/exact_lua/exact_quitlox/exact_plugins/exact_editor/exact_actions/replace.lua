return {
    {
        "nvim-pack/nvim-spectre",
        cmd = {
            "Replace",
            "ReplaceWord",
            "ReplaceFile",
            "ReplaceVisual",
        },
        keys = {
            { "<C-F>", function() require("spectre").open() end, desc = "Find & Replace" },
            {
                "<C-F>",
                function() require("spectre").open_visual({ select_word = true }) end,
                desc = "Find & Replace",
                mode = {
                    "v",
                },
            },
        },
    },
    require("quitlox.util").legendary({
        { ":Replace", "Find & Replace" },
        { ":ReplaceWord", "Replace & Replace under cursor" },
        { ":ReplaceFile", "Replace & Replace in file" },
        { ":ReplaceVisual", "Replace & Replace visual selection" },
    }),
}
