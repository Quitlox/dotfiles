-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

-- We use sentiment.nvim for highlighting instead of vim-matchup
vim.g.matchup_matchparen_enabled = 0

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    matchup = {
        enable = true,
    },
})
