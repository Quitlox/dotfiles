-- +---------------------------------------------------------+
-- | abecodes/tabout.nvim                                    |
-- +---------------------------------------------------------+

require("tabout").setup({
    tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        -- Custom
        { open = "*", close = "*" },
        { open = "**", close = "**" },
        { open = "```", close = "```" },
    },
})
