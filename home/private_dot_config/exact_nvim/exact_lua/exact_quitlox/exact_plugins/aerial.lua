-- +---------------------------------------------------------+
-- | stevearc/aerial.nvim: Symbols Outline                   |
-- +---------------------------------------------------------+

require("aerial").setup({
    backends = { "lsp", "treesitter", "markdown", "man" },

    -- A list of all symbols to display. Set to false to display all symbols.
    -- This can be a filetype map (see :help aerial-filetype-map)
    -- To see all available values, see :help SymbolKind
    filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
    },

    -- HACK: fix lua's weird choice for `Package` for control structures like if/else/for/etc.
    icons = {
        lua = {
            Package = " ",
        },
    },

    -- LazyVim guides
    show_guides = false,
    guides = {
        mid_item = "├╴",
        last_item = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
    },
})

vim.keymap.set("n", "<leader>ls", "<cmd>AerialOpen<cr>", { desc = "Locate Symbols" })
vim.keymap.set("n", "<leader>oo", "<cmd>AerialOpen<cr>", { desc = "Open Outline" })
