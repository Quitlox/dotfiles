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
-- stylua: ignore start
vim.keymap.set({ "n", "v", }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "o" }, "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
-- stylua: ignore end

-- NOTE: There are some limitations due to `mini.ai` and `nvim-surround`:
-- 1. I cannot map `S` in `v` mode, as this would override `nvim-surround`'s functionality of surrounding a selection.
-- 2. Mapping `s` or `S` in `o` mode is a no-op, as `mini.ai` overwrite the whole `o` mode.
-- 3. I also don't map `x` mode, but I don't remember why.
