-- +---------------------------------------------------------+
-- | rcarriga/nvim-notify: Notifications                     |
-- +---------------------------------------------------------+

require("notify").setup({
    top_down = true,
})

-- Set up as default notification handler
local notify = require("notify")
vim.notify = function(msg, level, opts)
    notify(msg, level, opts)
end

vim.keymap.set("n", "<leader>vd", function()
    require("notify").dismiss({ pedning = true, silent = true })
end, { desc = "Dismiss Notifications" })
vim.keymap.set("n", "<leader>vln", function()
    require("telescope").extensions.notify.notify(require("telescope.themes").get_dropdown())
end, { desc = "List Notifications", nowait = true })
