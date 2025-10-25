-- +---------------------------------------------------------+
-- | stevearc/aerial.nvim: Symbols Outline                   |
-- +---------------------------------------------------------+

require("aerial").setup({
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = {
        -- NOTE: Options below (except styling) required for compatiblity with edgy.nvim
        win_opts = {
            winfixwidth = false,
        },
        default_direction = "left",
        placement = "window",
        preserve_equality = false,
        resize_to_content = false,
    },

    keymaps = {
        ["i"] = "actions.jump",
        ["o"] = "actions.jump",
        ["<S-j>"] = "actions.down_and_scroll",
        ["<S-k>"] = "actions.up_and_scroll",
        ["<C-j>"] = false,
        ["<C-k>"] = false,
    },

    -- HACK: fix lua's weird choice for `Package` for control structures like if/else/for/etc.
    icons = { lua = { Package = " " } },

    -- LazyVim guides
    show_guides = false,
    guides = {
        mid_item = "├╴",
        last_item = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline" })

--+- Keymaps: Override Defaults -----------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        -- Overwrite ftplugin/markdown.lua
        vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline", buffer = 0 })
    end,
})
