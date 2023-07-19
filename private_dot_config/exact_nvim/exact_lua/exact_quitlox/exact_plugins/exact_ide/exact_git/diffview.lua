----------------------------------------------------------------------
--                             DiffView                             --
----------------------------------------------------------------------
-- Improves the standard vimdiff mode, adding better highlighting and shortcuts.

return {
    {
        "sindrets/diffview.nvim",
        config = true,
        keys = {
            { "<leader>gd", "<cmd>DiffviewFileHistory<cr>", desc = "Git Diff File History" },
        },
        lazy = false,
        -- cmd = {
        --     "DiffviewFileHistory",
        --     "DiffviewOpen",
        --     "DiffviewClose",
        --     "DiffviewToggleFiles",
        --     "DiffviewFocusFiles",
        --     "DiffviewRefresh",
        -- },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                { "DiffviewFileHistory", description = "Diffview File History" },
                { "DiffviewOpen", description = "Diffview Open (compare against current index)" },
                { "DiffviewClose", description = "Diffview Close" },
                { "DiffviewToggleFiles", description = "Diffview Toggle files" },
                { "DiffviewFocusFiles", description = "Diffview Locate (focus) files" },
                { "DiffviewRefresh", description = "Diffview Refresh" },
                -- See https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md 
                { "DiffviewReviewPR", "DiffviewOpen origin/HEAD...HEAD --imply-local", description = "Diffview to review a Pull Request"},
                { "DiffviewReviewPRByCommit", "DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges", description = "Diffview to review a Pull Request"},
            })
        end,
    },
}
