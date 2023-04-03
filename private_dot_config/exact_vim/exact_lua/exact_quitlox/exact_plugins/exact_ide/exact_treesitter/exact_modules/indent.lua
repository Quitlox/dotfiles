----------------------------------------------------------------------
--                        Treesitter: Indent                        --
----------------------------------------------------------------------
-- Treesitter based indentation
-- TODO: This should be superceded by standard treesitter, but currently indentation in Python is too shit and needs a different solution

return {
    "yioneko/nvim-yati",
    cond = false,
    ft = { "python" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ----- Indenting -----
            indent = {
                enable = true,
                -- See yati below
                disable = { "python", "latex" },
            },
            -- Temporary plugin for Python indentation
            -- since the default treesitter implementation sucks.
            yati = { enable = true, disable = { "toml" } },
        })
    end,
}
