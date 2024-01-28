----------------------------------------------------------------------
--                            Treesitter                            --
----------------------------------------------------------------------
-- Enables advanced syntax highlighting and indentation for many
-- languages.

return {
    { import = "quitlox.plugins.ide.treesitter" },
    -- Modules
    { import = "quitlox.plugins.ide.treesitter.modules" },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        version = "",
        build = ":TSUpdate",
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
        opts = {
            ensure_installed = {
                "lua",
                "luadoc",
                "luap",
                -- Dependencies
                "regex",
                "markdown",
                "markdown_inline",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            ----- Highlight -----
            highlight = {
                -- `false` will disable the whole extension
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages

                additional_vim_regex_highlighting = { "latex" },
                disable = { "latex" },
            },

            ----- Incremental Selection -----
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                },
            },
        },
    },
}
