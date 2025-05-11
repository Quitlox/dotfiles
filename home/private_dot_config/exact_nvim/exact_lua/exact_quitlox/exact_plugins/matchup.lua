-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

--+- Options ------------------------------------------------+
-- Disable built-in vim matchit plugin (should happen automatically, but just in case)
-- vim.g.loaded_matchit = 1

vim.g.matchup_surround_enabled = 1 -- Provided by surround.nvim
vim.g.matchup_text_obj_enabled = 0 -- Conflicts with mini.ai
vim.g.matchup_transmute_enabled = 1 -- Experimental transmute feature (change matching pairs simultaneously)

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    matchup = {
        enable = true,
    },
})

--+- Keymap -------------------------------------------------+
require("which-key").add({
    { "[%", desc = "Prev Match" },
    { "]%", desc = "Next Match" },
})
