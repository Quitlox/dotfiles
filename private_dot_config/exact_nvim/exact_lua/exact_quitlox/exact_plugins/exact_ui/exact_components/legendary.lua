
local function DismissNotifications()
    require('notify').dismiss({pending = true, silent=true})
end

return {
    "mrjones2014/legendary.nvim",
    version = "",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
        require("legendary").setup({
            commands = { {
                    ':DismissNotifications',
                    DismissNotifications,
                    description = 'Dismiss all notifications'
                }, },
            which_key = {
                auto_register = true,
                do_binding = false,
            },
        })

        require("which-key").register({
            k = { "<cmd>Legendary<cr>", "Keymap" },
            d = {"<cmd>DismissNotifications<cr>", "Dismiss Notifications"},
        }, { prefix = "<leader>v" })
    end,
    extensions = {
        nvim_tree=true,
        smart_splits=true,
        diffview=true,
    }
}
