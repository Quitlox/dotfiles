function CloseNotification()
    require("which-key").register({
        q = { ":q<cr>", "Close Notification" },
    }, { mode = "n", buffer = vim.api.nvim_get_current_buf() })
end

vim.cmd([[ autocmd FileType notify lua CloseNotification() ]])

-- Set up as default notification handler
vim.notify = function(msg, level, opts) require("notify")(msg, level, opts) end

return {
    "rcarriga/nvim-notify",
    version = "",
    keys = {
        {
            "<leader>vd",
            function() require("notify").dismiss({ pedning = true, silent = true }) end,
            desc = "Dismiss Notifications",
        },
        {
            "<leader>vn",
            function() require("telescope").extensions.notify.notify(require("telescope.themes").get_dropdown()) end,
            desc = "List Notifications",
            nowait = true,
        },
    },
    opts = {
        top_down = false,
    },
}
