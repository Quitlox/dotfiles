return {
    "rcarriga/nvim-notify",
    config = function()
        -- Set up notify
        local notify = require("notify")
        notify.setup({
            top_down = false,
            max_width = function() return math.floor(math.max(vim.o.columns / 2, 30)) end,
        })

        -- Set up as default notification handler
        vim.notify=notify

        -- Install telescope extension
        require("telescope").load_extension("notify")
    end,
    init = function()
        require("which-key").register({
            v = {
                name = "Vim",
                l = {
                    name = "list",
                    n = { "<cmd>Telescope notify<cr>", "Vim List Notifications" },
                },
            },
        }, { prefix = "<leader>" })
    end,
}
