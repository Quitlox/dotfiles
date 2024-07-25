-- +---------------------------------------------------------+
-- | folke/flash.nvim: Sneak + Enhanced f/t                  |
-- +---------------------------------------------------------+

-- Options
require("flash").setup({
    modes = {
        search = {
            enabled = false, -- Annoying when searching for something that may not exist.
        },
    },
})

-- Keymaps
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "o" }, "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- NOTE: I explicitly removed mode "x" for the "S" mapping, as this would conflict with nvim-surround.
--          namely, surrounding the selection
