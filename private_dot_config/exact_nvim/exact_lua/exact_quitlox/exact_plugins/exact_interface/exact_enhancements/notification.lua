function CloseNotification()
    require('which-key').register({
        q = { ":q<cr>", "Close Notification" },
    },{mode="n",buffer = vim.api.nvim_get_current_buf()})
end

vim.cmd([[ autocmd FileType notify lua CloseNotification() ]])

return {
    "rcarriga/nvim-notify",
    version = "",
    priority = 800,
    config = function()
        -- Set up notify
        local notify = require("notify")
        notify.setup({
            top_down = false,
            max_width = function() return math.floor(math.max(vim.o.columns / 2, 30)) end,
        })

        -- Set up as default notification handler
        vim.notify = notify

        -- Install telescope extension
        require("telescope").load_extension("notify")
    end,
    init = function()
        require('legendary').command({
            ":ListNotifications",
            function()
                require('telescope').extensions.notify.notify()
            end,
            description = "List Notifications",
        })

    end,
}
