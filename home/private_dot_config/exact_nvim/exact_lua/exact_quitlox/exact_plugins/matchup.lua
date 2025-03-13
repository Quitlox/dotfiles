-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

-- Disable built-in vim matchit plugin (should happen automatically, but just in case)
vim.g.loaded_matchit = 1
-- Provided by surround.nvim
vim.g.matchup_surround_enabled = 1
-- Conflicts with mini.ai
vim.g.matchup_text_obj_enabled = 0

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    matchup = {
        enable = true,
        -- disable = { "rust", "javascript", "tsx", "svelte" }, -- FIXME: Having problems
    },
})

-- FIXME: I had to completely disable vim-matchup due to problems with rust completion.
-- NOTE:? I re-enabled due to switch to blink.cmp, is it now fixed?
-- https://github.com/hrsh7th/nvim-cmp/issues/1940

--+- Keymap -------------------------------------------------+
require("which-key").add({
    { "[%", desc = "Prev Parenthesis" },
    { "]%", desc = "Next Parenthesis" },
})
