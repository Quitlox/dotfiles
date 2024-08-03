-- Set up as default notification handler
vim.notify = function(msg, level, opts)
    require("notify")(msg, level, opts)
end

return {
    "rcarriga/nvim-notify",
    version = "",
    keys = {
        -- stylua: ignore start
        { "<leader>vd", function() require("notify").dismiss({ pedning = true, silent = true }) end, desc = "Dismiss Notifications" },
        { "<leader>vln", function() require("telescope").extensions.notify.notify(require("telescope.themes").get_dropdown()) end, desc = "List Notifications", nowait = true },
        -- stylua: ignore end
    },
    opts = {
        top_down = false,
    },
}
