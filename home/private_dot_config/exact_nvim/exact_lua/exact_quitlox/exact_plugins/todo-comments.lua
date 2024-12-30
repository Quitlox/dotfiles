-- +---------------------------------------------------------+
-- | folke/todo-comments.nvim: Todo Comments                 |
-- +---------------------------------------------------------+

require("todo-comments").setup({
    highlight = {
        keyword = "wide",
    },
    keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>on", "<cmd>TodoTrouble<cr>", { desc = "Open Notes" })
vim.keymap.set("n", "<leader>fn", "<cmd>TodoTelescope<cr>", { desc = "Find Notes" })
vim.keymap.set("n", "[n", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous Note" })
vim.keymap.set("n", "]n", function()
    require("todo-comments").jump_next()
end, { desc = "Next Note" })
