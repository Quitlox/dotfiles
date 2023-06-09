return {
    "TimUntersberger/neogit",
    config = true,
    opts = {
        kind = "split",
        integrations = {
            diffview = true,
        },
    },
    cmd = {
        "Neogit",
    },
    init = function()
        require("which-key").register({
            g = { "<cmd>Neogit<cr>", "Git Status" },
        }, { prefix = "<leader>o" })

        require("legendary").commands({
            {
                ":Neogit",
                description = "Open Neogit",
            },
            {
                "<cmd>Telescope git_branches<cr>",
                description = "View Git Branches",
            },
        })
    end,
}
