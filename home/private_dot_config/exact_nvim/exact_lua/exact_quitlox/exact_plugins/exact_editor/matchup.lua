-- +---------------------------------------------------------+
-- | andymass/vim-matchup: Modern matchit and matchparen     |
-- +---------------------------------------------------------+

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    matchup = {
        enable = true,
        disable = { "rust", "javascript", "tsx", "svelte" }, -- FIXME: Having problems
    },
})

-- FIXME: I had to completely disable vim-matchup due to problems with rust completion.
-- https://github.com/hrsh7th/nvim-cmp/issues/1940
