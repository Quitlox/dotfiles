-- +---------------------------------------------------------+
-- | bassamsdata/namu.nvim: Fancy Symbol Searcher            |
-- +---------------------------------------------------------+

require("namu").setup({
    namu_symbols = {
        enable = true,
        options = {
            AllowKinds = {
                python = { "Function", "Class", "Method" },
            },

            movement = {
                next = { "<C-n>", "<C-j>", "<DOWN>" },
                previous = { "<C-p>", "<C-k>", "<UP>" },
                close = { "<ESC>" },
                select = { "<CR>" },
                delete_word = {},
                clear_line = {},
            },
            window = {
                min_width = 40,
            },
        },
    },
})

--+- FileType: lua ------------------------------------------+
vim.keymap.set("n", "go", ":Namu symbols<cr>", {
    desc = "Jump to symbol",
    silent = true,
})
vim.keymap.set("n", "gs", ":Namu workspace<cr>", {
    desc = "Jump to workspace symbol",
    silent = true,
})
