-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    matchup = {
        enable = true,
        disable = { "tsx", "svelte" },
    },
})
