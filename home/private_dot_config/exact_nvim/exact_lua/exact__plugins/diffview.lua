-- +---------------------------------------------------------+
-- | sindrets/diffview.nvim: Diffview                        |
-- +---------------------------------------------------------+

-- Keymaps: Trace line evolution
vim.keymap.set("n", "<leader>gl", ":.DiffviewFileHistory --follow<cr>", { desc = "Line History (Diffview)" })
vim.keymap.set("v", "<leader>gl", ":'<,'>DiffviewFileHistory --follow<cr>", { desc = "Line History (Diffview)" })

-- Keymap: Diff against main
vim.keymap.set("n", "<leader>gm", function()
    -- Try main first, fall back to master
    local result = vim.fn.systemlist({ "git", "rev-parse", "--verify", "main" })
    local ok = vim.v.shell_error == 0 and result[1] ~= nil and result[1] ~= ""
    local branch = ok and "main" or "master"
    vim.cmd("DiffviewOpen " .. branch)
end, { desc = "Diff against main" })

-- Extra Commands
vim.api.nvim_create_user_command("DiffviewCurrentFileHistory", "DiffviewFileHistory %", {
    desc = "Diffview File History",
})
vim.api.nvim_create_user_command("DiffviewReviewPR", "DiffviewOpen origin/HEAD...HEAD --imply-local", {
    desc = "Diffview to review a Pull Request",
})
vim.api.nvim_create_user_command("DiffviewReviewPRByCommit", "DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges", {
    desc = "Diffview to review a Pull Request",
})

-- State
local diffview_state = "closed"

-- Configuration
require("diffview").setup({
    -- Enhanced diffing (uses diffchar.vim)
    enhanced_diff_hl = true,
    diffopt = { algorithm = "histogram" },

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
            -- Re-enable treesitter-context after closing diffview
            local ok, tsc = pcall(require, "treesitter-context")
            if ok and tsc.enabled() then
                tsc.enable()
            end
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
            -- Re-trigger treesitter-context's on_attach evaluation
            pcall(vim.api.nvim_exec_autocmds, "BufReadPost", {
                buffer = bufnr,
                group = "treesitter_context_update",
            })
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
