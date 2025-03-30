-- +---------------------------------------------------------+
-- | otavioschwanck/arrow.nvim: Buffer Bookmark              |
-- +---------------------------------------------------------+

require("arrow").setup({
    show_icons = true,

    leader_key = "=",
    buffer_leader_key = "+",

    per_buffer_config = {
        lines = 8,
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
    { "+", desc = "Arrow (Buffer)" },
})
