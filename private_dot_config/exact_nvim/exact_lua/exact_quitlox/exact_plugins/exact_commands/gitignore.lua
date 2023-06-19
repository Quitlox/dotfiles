return {
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = "Gitignore",
        lazy = true,
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":Gitignore",
                ":Gitignore",
                description = "Generate .gitignore file",
            })
        end,
    },
}
