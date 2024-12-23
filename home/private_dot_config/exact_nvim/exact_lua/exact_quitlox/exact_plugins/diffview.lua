-- +---------------------------------------------------------+
-- | sindrets/diffview.nvim: Diffview                        |
-- +---------------------------------------------------------+

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

-- State
local diffview_state = "closed"

-- Configuration
require("diffview").setup({
    keymaps = {
        view = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close the DiffView Tab" } },
        },
        file_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close the DiffView Tab" } },
        },
        file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close the DiffView Tab" } },
        },
    },
    hooks = {
        view_opened = function(view)
            diffview_state = "open"
        end,
        view_closed = function(view)
            diffview_state = "closed"
        end,
    },
})

-- Close DiffView on exit (preventing session manager from saving tab)
vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("MyCloseDiffViewOnExit", { clear = true }),
    callback = function()
        if diffview_state == "open" then
            vim.cmd("DiffviewClose")
        end
    end,
})
