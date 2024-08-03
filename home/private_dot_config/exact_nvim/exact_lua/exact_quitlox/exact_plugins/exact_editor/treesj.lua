-- +---------------------------------------------------------+
-- | wansmer/treesj: Split / Join blocks of code             |
-- +---------------------------------------------------------+

local function setup()
    require("treesj").setup({
        max_join_length = 300,
        use_default_keymaps = false,
    })

    vim.keymap.set("n", "<leader>j", require("treesj").join, { noremap = true, desc = "Join" })
    vim.keymap.set("n", "<leader>s", require("treesj").split, { noremap = true, desc = "Split" })
end

require("quitlox.util.lazy").keymap_stub("n", "<leader>j", setup, { noremap = true, desc = "Join" })
require("quitlox.util.lazy").keymap_stub("n", "<leader>s", setup, { noremap = true, desc = "Split" })
