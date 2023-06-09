----------------------------------------------------------------------
--                             DiffView                             --
----------------------------------------------------------------------
-- Improves the standard vimdiff mode, adding better highlighting and shortcuts.

return {
    "sindrets/diffview.nvim",
    config = true,
    cmd = {
        "DiffviewFileHistory",
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
    },
    init = function()
        -- require("which-key").register({
        --     g = {
        --         name = "Git",
        --         d = {
        --             name = "Diff",
        --             h = { "<cmd>DiffviewFileHistory<cr>", "Git Diff History" },
        --             f = { "<cmd>DiffviewFileHistory %<cr>", "Git Diff File history" },
        --             o = { "<cmd>DiffviewOpen<cr>", "Git Diff Open (compare against current index)" },
        --             c = { "<cmd>DiffviewClose<cr>", "Git Diff Close" },
        --             t = { "<cmd>DiffviewToggleFiles<cr>", "Git Diff Toggle files" },
        --             l = { "<cmd>DiffviewFocusFiles<cr>", "Git Diff Locate (focus) files" },
        --             r = { "<cmd>DiffviewRefresh<cr>", "Git Diff Refresh" },
        --         },
        --     },
        -- }, { prefix = "<leader>" })

        require('legendary').command({
            ":DiffviewFileHistory",
            description = "Git Diff History",
        })
        require('legendary').command({
            ":DiffviewFileHistory %",
            description = "Git Diff File history",
        })
        require('legendary').command({
            ":DiffviewOpen",
            description = "Git Diff Open (compare against current index)",
        })
        require('legendary').command({
            ":DiffviewClose",
            description = "Git Diff Close",
        })
        require('legendary').command({
            ":DiffviewToggleFiles",
            description = "Git Diff Toggle files",
        })
        require('legendary').command({
            ":DiffviewFocusFiles",
            description = "Git Diff Locate (focus) files",
        })
        require('legendary').command({
            ":DiffviewRefresh",
            description = "Git Diff Refresh",
        })

    end,
}
