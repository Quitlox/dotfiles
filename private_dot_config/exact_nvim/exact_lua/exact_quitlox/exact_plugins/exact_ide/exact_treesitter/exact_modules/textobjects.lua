----------------------------------------------------------------------
--                  Treesitter: TextObjects                         --
----------------------------------------------------------------------

return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ----- Text Objects -----
                textobjects = {
                    move = {
                        enable = true,
                        lookahead = true,

                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                            ["]b"] = "@block.outer",
                            ["]l"] = "@loop.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]B"] = "@block.outer",
                            ["]L"] = "@loop.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                            ["[b"] = "@block.outer",
                            ["[l"] = "@loop.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.outer",
                            ["[B"] = "@block.outer",
                            ["[L"] = "@loop.outer",
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
                            ["ad"] = "@statement.outer",
                            ["id"] = "@statement.inner", -- Not used by any language
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "v", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                            ["@statement.outer"] = "v", -- blockwise
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            })

            require("which-key").register({
                ["<leader>"] = {
                    ["a"] = { "Swap Next" },
                    ["A"] = { "Swap Previous" },
                },
            })
        end,
    },
}
