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
        vim.notify=notify

        -- Install telescope extension
        require("telescope").load_extension("notify")
    end,
    init = function()
        require("quitlox.util.which_key").register({
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
