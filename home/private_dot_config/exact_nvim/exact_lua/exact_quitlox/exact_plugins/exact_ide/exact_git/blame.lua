return {
    {
        "f-person/git-blame.nvim",
        cmd = {
            "GitBlameToggle",
            "GitBlameEnable",
            "GitBlameDisable",
            "GitBlameCopySHA",
            "GitBlameCopyCommitURL",
            "GitBlameOpenFileURL",
            "GitBlameCopyFileURL",
        },
        keys = {
            { "<leader>Tb", ":GitBlameToggle<CR>", desc = "Toggle Git Blame" },
        },
        init = function() vim.g.gitblame_highlight_group = "@tag.delimiter" end,
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":GitBlameToggle",
                description = "Toggle Git Blame",
            })
            table.insert(opts.commands, {
                ":GitBlameEnable",
                description = "Enable Git Blame",
            })
            table.insert(opts.commands, {
                ":GitBlameDisable",
                description = "Disable Git Blame",
            })
            table.insert(opts.commands, {
                ":GitBlameCopySHA",
                description = "Copy Git SHA",
            })
            table.insert(opts.commands, {
                ":GitBlameCopyCommitURL",
                description = "Copy Git Commit URL",
            })
            table.insert(opts.commands, {
                ":GitBlameOpenFileURL",
                description = "Open Git File URL",
            })
            table.insert(opts.commands, {
                ":GitBlameCopyFileURL",
                description = "Copy Git File URL",
            })
        end,
    },
}
