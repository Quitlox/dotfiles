----------------------------------------------------------------------
--                  Treesitter: TextObjects                         --
----------------------------------------------------------------------

return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- TODO: Re-enable (I have problems with typescript files)
        enabled = true,
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
                            ["]C"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                            ["]b"] = "@block.outer",
                            ["]l"] = "@loop.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            -- ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]B"] = "@block.outer",
                            ["]L"] = "@loop.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                            ["[b"] = "@block.outer",
                            ["[l"] = "@loop.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            -- ["[C"] = "@class.outer",
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
                            ["aC"] = "@class.outer",
                            ["iC"] = "@class.inner",
                            ["ad"] = "@statement.outer",
                            ["id"] = "@statement.inner", -- Not used by any language
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "v", -- linewise
                            ["@class.outer"] = "v", -- blockwise
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
        end,
    },
    require("quitlox.util").legendary({
        { "<leader>a", desc = "Swap Next" },
        { "<leader>A", desc = "Swap Previous" },
    }),
    require("quitlox.util").whichkey({
        { "<leader>a", desc = "Swap Next" },
        { "<leader>A", desc = "Swap Previous" },
    }),
    {
        "chrisgrieser/nvim-various-textobjs",
        lazy = false,
        opts = { useDefaultKeymaps = false },
        keys = {
            { "aS", "<cmd>lua require('various-textobjs').subword('outer')<CR>", mode = { "o", "x" } },
            { "iS", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = { "o", "x" } },
        },
    },
}
