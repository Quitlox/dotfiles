----------------------------------------------------------------------
--               Dial - Enhanced Increment/Decrement                --
----------------------------------------------------------------------

return {
    -- Enhanced increment/decrement
    {
        "monaqa/dial.nvim",
        version = "",
        keys = {
            { "<C-x>", mode = "v" },
            { "<C-a>", mode = "v" },
            "<C-x>",
            "<C-a>",
        },
        config = function()
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
        end,
    },
}
