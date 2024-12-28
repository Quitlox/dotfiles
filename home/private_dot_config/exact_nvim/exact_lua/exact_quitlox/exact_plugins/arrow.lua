-- +---------------------------------------------------------+
-- | otavioschwanck/arrow.nvim: Buffer Bookmark              |
-- +---------------------------------------------------------+

require("arrow").setup({
    show_icons = true,

    leader_key = "=",
    buffer_leader_key = "m",

    per_buffer_config = {
        lines = 8,
        treesitter_context = { line_shift_down = -2 },
    },

    mappings = {
        open_vertical = "b",
        open_horizontal = "v",
    },
})

vim.keymap.set("n", "[b", require("arrow.persist").previous)
vim.keymap.set("n", "]b", require("arrow.persist").next)

-- require("quitlox.util.lazy").keymap_stub("n", "=", setup_arrow, { noremap = true, silent = true })
