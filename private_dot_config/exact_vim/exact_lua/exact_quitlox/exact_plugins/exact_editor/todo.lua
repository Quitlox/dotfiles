----------------------------------------------------------------------
--                          Trouble: Todo                           --
----------------------------------------------------------------------
-- Plugin that uses Trouble to display TODOs and other notes.

return {
    "folke/todo-comments.nvim",
    version = "",
    config = true,
    opts = {
        highlight = {
            keyword = "wide",
        },
    },
    init = function()
        require("which-key").register({
            d = {
                name = "Diagnostics",
                n = { "<cmd>TodoTrouble<cr>", "Open Notes" },
            },
        }, { prefix = "<leader>o", noremap = true })

        local wk = require("which-key")

        wk.register({
            ["]n"] = {
                function() require("todo-comments").jump_next() end,
                "Next note",
            },
            ["[n"] = {
                function() require("todo-comments").jump_prev() end,
                "Previous note",
            },
        }, { mode = "n" })
    end,
}
