-- +---------------------------------------------------------+
-- | wansmer/treesj: Split / Join blocks of code             |
-- +---------------------------------------------------------+

require("treesj").setup({
    max_join_length = 300,
    use_default_keymaps = false,
})

vim.keymap.set("n", "<leader>j", require("treesj").toggle, { noremap = true, desc = "Join" })
-- vim.keymap.set("n", "<leader>s", require("treesj").split, { noremap = true, desc = "Split" })
