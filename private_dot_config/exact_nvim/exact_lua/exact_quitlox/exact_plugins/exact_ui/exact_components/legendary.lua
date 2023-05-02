local function dismissNotifications() require("notify").dismiss({ pending = true, silent = true }) end

return {
    {
        "mrjones2014/legendary.nvim",
        version = "",
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
            require("legendary").setup({
                commands = {
                    {
                        ":DismissNotifications",
                        dismissNotifications,
                        description = "Dismiss all notifications",
                    },
                    {
                        ":Gitignore",
                        description = "Create .gitignore file",
                    },
                },
                which_key = {
                    auto_register = true,
                    do_binding = false,
                },
            })

            require("which-key").register({
                k = { "<cmd>Legendary<cr>", "Keymap" },
                d = { "<cmd>DismissNotifications<cr>", "Dismiss Notifications" },
            }, { prefix = "<leader>v" })
        end,
        extensions = {
            nvim_tree = true,
            smart_splits = true,
            diffview = true,
        },
    },
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = "Gitignore",
        lazy = true,
    },
}
