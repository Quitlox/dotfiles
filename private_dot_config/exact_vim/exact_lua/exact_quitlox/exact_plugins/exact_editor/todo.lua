----------------------------------------------------------------------
--                          Trouble: Todo                           --
----------------------------------------------------------------------
-- Plugin that uses Trouble to display TODOs and other notes.

return {
    "folke/todo-comments.nvim",
    config = true,
    opts = {
        highlight = {
            keyword = "wide",
        },
    },
    cmd = { "TodoTrouble" },
    init = function()
        require("which-key").register({
            d = {
                name = "Diagnostics",
                n = { "<cmd>TodoTrouble<cr>", "Open Notes" },
            },
        }, { prefix = "<leader>o", noremap = true })
    end,
}
