return {
    "mrjones2014/legendary.nvim",
    version = "",
    dependencies = { "kkharji/sqlite.lua" },
    priority = 900, -- Should be earlier than which-key
    config = function()
        require("legendary").setup({
            commands = { {
                    ':DismissNotifications',
                    function()
                        require('notify').dismiss({pending = true, silent=true})
                    end,
                    description = 'Dismiss all notifications'
                }, },
            which_key = {
                auto_register = false,
                do_binding = false,
            },
        })
        require("which-key").register({
            k = { "<cmd>Legendary<cr>", "Vim Keymap" },
        }, { prefix = "<leader>v" })
    end,
    extensions = {
        nvim_tree=true,
        smart_splits=true,
        diffview=true,
    }
}
