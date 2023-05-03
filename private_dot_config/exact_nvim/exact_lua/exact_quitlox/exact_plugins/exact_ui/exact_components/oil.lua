return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = false,
        keymaps = {

        ["q"] = "actions.close",
        },
    },
    lazy=true,
    init = function()
        require("which-key").register({
            ["<leader>o"] = {
                ["d"] = { '<cmd>lua require("oil").open_float()<cr>', "Open Directory" },
            },
        })
    end,
}
