-- +---------------------------------------------------------+
-- | stevearc/aerial.nvim: Symbols Outline                   |
-- +---------------------------------------------------------+

require("aerial").setup({
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = {
        placement = "edge",
        preserve_equality = true,
    },
    attach_mode = "global",

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

    keymaps = {
        ["i"] = "actions.jump",
        ["<S-j>"] = "actions.down_and_scroll",
        ["<S-k>"] = "actions.up_and_scroll",
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

-- stylua: ignore start
vim.keymap.set("n", "<leader>ls", function() vim.notify('noop', 'info') end, { desc = "Locate Symbols" })
vim.keymap.set("n", "<leader>oo", function() vim.notify('noop', 'info') end, { desc = "Open Outline" })
vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline" })
-- stylua: ignore end

--+- Keymaps: Override Defaults -----------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        -- Overwrite ftplugin/markdown.lua
        vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline", buffer = 0 })
    end,
})
