-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

--+- Options ------------------------------------------------+
vim.g.matchup_surround_enabled = 1 -- Provided by surround.nvim
vim.g.matchup_text_obj_enabled = 0 -- Conflicts with mini.ai
vim.g.matchup_transmute_enabled = 1 -- Experimental transmute feature (change matching pairs simultaneously)

vim.g.matchup_delim_noskips = 2 -- Do not match inside strings and comments
-- This is to prevent matching in e.g. the following case
-- ```lua
-- require("which-key").add({
--     { "[%", desc = "Prev Match" },
--     { "]%", desc = "Next Match" },
-- })
-- ```

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
