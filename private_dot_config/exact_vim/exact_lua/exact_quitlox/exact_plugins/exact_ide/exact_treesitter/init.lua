----------------------------------------------------------------------
--                            Treesitter                            --
----------------------------------------------------------------------
-- Enables advanced syntax highlighting and indentation for many
-- languages.

return {
    -- Modules
    { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" },
    { "windwp/nvim-autopairs", config = true, dependencies = "nvim-treesitter/nvim-treesitter" },
    { import = "quitlox.plugins.ide.treesitter.modules" },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
        opts = {
            ensure_installed = {
                -- Main Languages
                "c",
                "lua",
                "rust",
                "python",
                "java",
                "lua",
                -- Shell
                "vim",
                "bash",
                "cpp",
                -- Latex
                "latex",
                "bibtex",
                -- Build Environment
                "make",
                "cmake",
                "dockerfile",
                -- Supplemenatry Files
                "json",
                "jsonc",
                "markdown",
                "toml",
                "yaml",
                -- Web Development
                "graphql",
                "html",
                "scss",
                "tsx",
                "typescript",
                -- Dependencies
                "regex",
                "markdown_inline",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            auto_install = false,

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

            ----- Text Objects -----
            -- with: nvim-treesitter/nvim-treesitter-textobjects
            textobjects = {
                move = {
                    enable = true,
                    lookahead=true,

                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                        ["]b"] = "@block.outer",
                        -- ["]s"] = "@statement.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.outer",
                        ["]B"] = "@block.outer",
                        ["]L"] = "@loop.outer",
                        -- ["]S"] = "@statement.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                        ["[b"] = "@block.outer",
                        ["[l"] = "@loop.outer",
                        -- ["[s"] = "@statement.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.outer",
                        ["[B"] = "@block.outer",
                        ["[L"] = "@loop.outer",
                        -- ["[S"] = "@statement.outer",
                    },
                },
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        -- Defined by targets.nvim
                        -- ["aa"] = "@parameter.outer",
                        -- ["ia"] = "@parameter.inner", 
                        -- ["as"] = "@statement.outer",
                        -- ["is"] = "@statement.inner",
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "v", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                },
            },
        },
    },
}
