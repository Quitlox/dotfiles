return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>r"] = { name = "Replace" },
            }
        }
    },
    {
        "nvim-pack/nvim-spectre",
        keys = {
            { "<leader>rr", function() require("spectre").open() end,                              desc = "Replace" },
            { "<leader>rw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Replace Word" },
            { "<leader>rf", function() require("spectre").open_file_search() end,                  desc = "Replace File" },
            {
                "<leader>R",
                function() require("spectre").open_visual() end,
                desc = "Replace Visual",
                mode = "v",
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
                description = "Replace word under cursor in project",
            })
            table.insert(opts.commands, {
                ":ReplaceWord",
                function() require("spectre").open_visual({ select_word = true }) end,
                description = "Replace word under cursor in project",
            })
            table.insert(opts.commands, {
                ":ReplaceFile",
                function() require("spectre").open_file_search() end,
                description = "Replace in file",
            })
            table.insert(opts.commands, {
                ":ReplaceVisual",
                function() require("spectre").open_visual() end,
                description = "Replace visual selection",
            })
        end,
    },
}
