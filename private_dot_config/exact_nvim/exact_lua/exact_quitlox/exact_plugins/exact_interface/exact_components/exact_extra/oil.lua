return {
    {
        "stevearc/oil.nvim",
        version = "",
        opts = {
            default_file_explorer = true,
            keymaps = {
                ["q"] = "actions.close",
                ["<esc>"] = "actions.close",
            },
            view_optoins = {
                show_hidden = true,
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
            vim.list_extend(opts.commands, {
                -- stylua: ignore start
                { ":Oil", function() require("oil").open_float(vim.fn.getcwd()) end, description = "oil.nvim: Open" },
                { ":OilRoot", function() require("oil").open_float(vim.fn.getcwd()) end, description = "oil.nvim: Open in project root" },
                { ":OilDiscard", function() require("oil").discard_all_changes() end, description = "oil.nvim: Discard changes" },
                -- stylua: ignore end
            })
        end,
    },
}
