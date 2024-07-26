-- +---------------------------------------------------------+
-- | folke/todo-comments.nvim: Todo Comments                 |
-- +---------------------------------------------------------+

require("todo-comments").setup({
    highlight = {
        keyword = "wide",
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>on", "<cmd>TodoTrouble<cr>", { desc = "Open Notes" })
vim.keymap.set("n", "<leader>fn", "<cmd>TodoTelescope<cr>", { desc = "Find Notes" })
vim.keymap.set("n", "[n", function() require("todo-comments").jump_prev() end, { desc = "Previous Note" })
vim.keymap.set("n", "]n", function() require("todo-comments").jump_next() end, { desc = "Next Note" })
