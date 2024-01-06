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
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":Replace",
                function() require("spectre").open() end,
                description = "Find & Replace",
            })
            table.insert(opts.commands, {
                ":ReplaceWord",
                function() require("spectre").open_visual({ select_word = true }) end,
                description = "Replace & Replace under cursor",
            })
            table.insert(opts.commands, {
                ":ReplaceFile",
                function() require("spectre").open_file_search() end,
                description = "Replace & Replace in file",
            })
            table.insert(opts.commands, {
                ":ReplaceVisual",
                function() require("spectre").open_visual() end,
                description = "Replace & Replace visual selection",
            })
        end,
    },
}
