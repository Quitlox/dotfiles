function CloseNotification()
    require("which-key").register({
        q = { ":q<cr>", "Close Notification" },
    }, { mode = "n", buffer = vim.api.nvim_get_current_buf() })
end

vim.cmd([[ autocmd FileType notify lua CloseNotification() ]])

return {
    {
        "rcarriga/nvim-notify",
        version = "",
        priority = 800,
        lazy = false,
        keys = {
            {
                "<leader>vd",
                function() require("notify").dismiss({ pedning = true, silent = true }) end,
                desc = "Dismiss Notifications",
            },
        },
        config = function()
            -- Set up notify
            local notify = require("notify")
            notify.setup({
                top_down = false,
            })

            -- Set up as default notification handler
            vim.notify = notify
        end,
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":ListNotifications",
                function() require("telescope").extensions.notify.notify(require("telescope.themes").get_dropdown()) end,
                description = "List Notifications",
            })
        end,
    },
}
