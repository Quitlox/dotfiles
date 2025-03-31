-- +---------------------------------------------------------+
-- | bassamsdata/namu.nvim: Fancy Symbol Searcher            |
-- +---------------------------------------------------------+

require("namu").setup({
    namu_symbols = {
        enable = true,
        options = {
            movement = {
                next = { "<C-n>", "<C-j>", "<DOWN>" },
                previous = { "<C-p>", "<C-k>", "<UP>" },
                close = { "<ESC>" },
                select = { "<CR>" },
                delete_word = {},
                clear_line = {},
            },
        },
    },
})

--+- FileType: lua ------------------------------------------+
vim.keymap.set("n", "go", ":Namu symbols<cr>", {
    desc = "Jump to LSP symbol",
    silent = true,
})
