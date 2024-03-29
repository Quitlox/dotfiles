return {
    {
        "NeogitOrg/neogit",
        opts = {
            kind = "split",
            integrations = {
                diffview = true,
            },
        },
        cmd = { "Neogit" },
        keys = {
            { "<leader>og", "<cmd>Neogit<cr>", desc = "Open Git Status" },
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "Git Status" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":Neogit",
                description = "Open Neogit",
            })
        end,
    },
}
