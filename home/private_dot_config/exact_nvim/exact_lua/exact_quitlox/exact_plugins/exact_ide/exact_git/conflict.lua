return {
    {
        "akinsho/git-conflict.nvim",
        version = "",
        lazy = false,
        keys = {
            { "<leader>xo", "<Plug>(git-conflict-ours)",          desc = "Choose ours" },
            { "<leader>xt", "<Plug>(git-conflict-theirs)",        desc = "Choose theirs" },
            { "<leader>xb", "<Plug>(git-conflict-both)",          desc = "Choose both" },
            { "<leader>x0", "<Plug>(git-conflict-none)",          desc = "Choose none" },
            { "]x",         "<Plug>(git-conflict-next-conflict)", desc = "Next conflict" },
            { "[x",         "<Plug>(git-conflict-prev-conflict)", desc = "Previous conflict" },
        },
        opts = {
            default_mappings = false,
            default_command = true,
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                { "GitConflictChooseOurs",   description = "Conflict: Select the current changes." },
                { "GitConflictChooseTheirs", description = "Conflict: Select the incoming changes." },
                { "GitConflictChooseBoth",   description = "Conflict: Select both changes." },
                { "GitConflictChooseNone",   description = "Conflict: Select none of the changes." },
                { "GitConflictListQf",       description = "Conflict: Get all conflict to quickfix" },
                -- { "GitConflictNextConflict", description = "Move to the next conflict." },
                -- { "GitConflictPrevConflict", description = "Move to the previous conflict." },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>x"] = { name = "Conflict" },
            },
        },
    },
}
