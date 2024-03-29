----------------------------------------------------------------------
--                          Trouble: Todo                           --
----------------------------------------------------------------------
-- Plugin that uses Trouble to display TODOs and other notes.

return {
    "folke/todo-comments.nvim",
    version = "",
    event = "VeryLazy",
    opts = {
        highlight = {
            keyword = "wide",
        },
    },
    cmd = { "TodoTelescope", "TodoTrouble" },
    keys = {
        { "<leader>on", "<cmd>TodoTrouble<cr>", desc = "Open Notes" },
        { "<leader>fn", "<cmd>TodoTelescope<cr>", desc = "Find Notes" },
        { "[n", function() require("todo-comments").jump_prev() end, desc = "Previous Note" },
        { "]n", function() require("todo-comments").jump_next() end, desc = "Next Note" },
    },
}
