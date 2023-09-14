return {
    {
        "stevearc/oil.nvim",
        version = "",
        opts = {
            default_file_explorer = false,
            keymaps = {
                ["q"] = "actions.close",
            },
        },
        keys = {
            { "-", "<cmd>lua require('oil').open_float()<cr>", desc = "Directory" },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":Oil",
                function() require("oil").open_float(vim.fn.getcwd()) end,
                description = "Oil: Open",
            })
            table.insert(opts.commands, {
                ":OilRoot",
                function() require("oil").open_float(vim.fn.getcwd()) end,
                description = "Oil: Open in project root",
            })
            table.insert(opts.commands, {
                ":OilDiscard",
                function() require("oil").discard_all_changes() end,
                description = "Oil: Discard changes",
            })
        end,
    },
}
