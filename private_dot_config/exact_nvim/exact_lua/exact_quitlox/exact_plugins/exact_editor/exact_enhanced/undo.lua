return {
    "tzachar/highlight-undo.nvim",
    lazy = true,
    keys = { "u", "<C-r>" },
    config = function() require("highlight-undo").setup({}) end,
}
