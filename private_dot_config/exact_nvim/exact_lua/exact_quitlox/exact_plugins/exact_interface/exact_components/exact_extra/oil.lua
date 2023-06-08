return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = false,
        keymaps = {
            ["q"] = "actions.close",
        },
    },
    lazy = true,
    init = function()
        require("which-key").register({
            ["-"] = { '<cmd>lua require("oil").open_float()<cr>', "Directory" },
        })

        require("legendary").command({
            ":Oil",
            function()
                require("oil").open_float(vim.fn.getcwd())
            end,
            description = "Oil: Open"
        })

        require("legendary").command({
            ":OilRoot",
            function()
                require("oil").open_float(vim.fn.getcwd())
            end,
            description = "Oil: Open in project root"
        })

        require("legendary").command({
            ":OilDiscard",
            function()
                require("oil").discard_all_changes()
            end,
            description = "Oil: Discard changes"
        })
    end,
}
