-- +---------------------------------------------------------+
-- | nvim-treesitter/nvim-treesitter-textobjects: Extra      |
-- | Text Objects                                            |
-- +---------------------------------------------------------+

require("nvim-treesitter.configs").setup({
    textobjects = {
        move = {
            enable = true,
            lookahead = true,
            set_jumps = false,

            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]]"] = "@class.outer",
                ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]A"] = "@parameter.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[A"] = "@parameter.outer",
                ["[L"] = "@loop.outer",
            },
        },
        select = {
            enable = true,
            lookahead = true,

            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["a["] = "@class.outer",
                ["i["] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ad"] = "@statement.outer",
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
                ["<leader>a"] = { query = "@parameter.inner", desc = "Swap Next" },
            },
            swap_previous = {
                ["<leader>A"] = { query = "@parameter.inner", desc = "Swap Previous" },
            },
        },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyPythonTextObjects", { clear = true }),
    pattern = "python",
    callback = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                move = {
                    goto_next_start = {
                        ["]f"] = "@function.name",
                        ["]]"] = "@class.name",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.name",
                        ["[["] = "@class.name",
                    },
                },
            },
        })
    end,
})
