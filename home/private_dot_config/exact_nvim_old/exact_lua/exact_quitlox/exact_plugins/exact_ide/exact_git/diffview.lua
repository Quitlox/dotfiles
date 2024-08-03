----------------------------------------------------------------------
--                             DiffView                             --
----------------------------------------------------------------------
-- Improves the standard vimdiff mode, adding better highlighting and shortcuts.

return {
    {
        "sindrets/diffview.nvim",
        config = true,
        keys = {
            { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Git Diff File History" },
        },
        cmd = {
            "DiffviewFileHistory",
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
        },
    },
    require("quitlox.util").legendary_full({
        { ":DiffviewCurrentFileHistory","DiffviewFileHistory %", description = "Diffview File History" },
        { ":DiffviewOpen", description = "Diffview Open (compare against current index)" },
        { ":DiffviewClose", description = "Diffview Close" },
        { ":DiffviewToggleFiles", description = "Diffview Toggle files" },
        { ":DiffviewFocusFiles", description = "Diffview Locate (focus) files" },
        { ":DiffviewRefresh", description = "Diffview Refresh" },
        -- See https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md
        { ":DiffviewReviewPR", "DiffviewOpen origin/HEAD...HEAD --imply-local", description = "Diffview to review a Pull Request" },
        { ":DiffviewReviewPRByCommit", "DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges", description = "Diffview to review a Pull Request" },
    }),
}
