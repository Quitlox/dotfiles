-- +---------------------------------------------------------+
-- | sindrets/diffview.nvim: Diffview                        |
-- +---------------------------------------------------------+

-- Keymaps
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { noremap = true, silent = true, desc = "Git Diff File History" })

-- Commands
require("legendary").commands({
    { ":DiffviewCurrentFileHistory", "DiffviewFileHistory %", description = "Diffview File History" },
    { ":DiffviewOpen", description = "Diffview Open (compare against current index)" },
    { ":DiffviewClose", description = "Diffview Close" },
    { ":DiffviewToggleFiles", description = "Diffview Toggle files" },
    { ":DiffviewFocusFiles", description = "Diffview Locate (focus) files" },
    { ":DiffviewRefresh", description = "Diffview Refresh" },
    -- See https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md
    { ":DiffviewReviewPR", "DiffviewOpen origin/HEAD...HEAD --imply-local", description = "Diffview to review a Pull Request" },
    { ":DiffviewReviewPRByCommit", "DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges", description = "Diffview to review a Pull Request" },
})

-- TODO: Use this in workflow
