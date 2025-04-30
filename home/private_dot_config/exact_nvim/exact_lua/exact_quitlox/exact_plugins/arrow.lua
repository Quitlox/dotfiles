-- +---------------------------------------------------------+
-- | otavioschwanck/arrow.nvim: Buffer Bookmark              |
-- +---------------------------------------------------------+

require("arrow").setup({
    show_icons = true,

    leader_key = "=",
    buffer_leader_key = "M",

    per_buffer_config = {
        treesitter_context = {
            line_shift_down = 4,
        },
        lines = 10,
        zindex = 10,
    },

    mappings = {
        open_vertical = "b",
        open_horizontal = "v",
    },
})

vim.keymap.set("n", "[b", require("arrow.persist").previous, { desc = "Prev Buffer (Arrow)" })
vim.keymap.set("n", "]b", require("arrow.persist").next, { desc = "Next Buffer (Arrow)" })

require("which-key").add({
    { "=", desc = "Arrow" },
    { "M", desc = "Arrow (Buffer)" },
})
