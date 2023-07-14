return {
    {
        "akinsho/git-conflict.nvim",
        version = "",
        lazy = false,
        keys = {
            { "<leader>co", "<Plug>(git-conflict-ours)",          desc = "Choose ours" },
            { "<leader>ct", "<Plug>(git-conflict-theirs)",        desc = "Choose theirs" },
            { "<leader>cb", "<Plug>(git-conflict-both)",          desc = "Choose both" },
            { "<leader>c0", "<Plug>(git-conflict-none)",          desc = "Choose none" },
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
                { "GitConflictChooseOurs",   description = "Select the current changes." },
                { "GitConflictChooseTheirs", description = "Select the incoming changes." },
                { "GitConflictChooseBoth",   description = "Select both changes." },
                { "GitConflictChooseNone",   description = "Select none of the changes." },
                { "GitConflictNextConflict", description = "Move to the next conflict." },
                { "GitConflictPrevConflict", description = "Move to the previous conflict." },
                { "GitConflictListQf",       description = "Get all conflict to quickfix" },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>c"] = { name = "Conflict" },
            },
        },
    },
}
