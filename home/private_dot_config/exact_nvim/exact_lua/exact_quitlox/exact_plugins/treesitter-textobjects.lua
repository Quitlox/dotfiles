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
                ["]m"] = { query = "@function.outer", desc = "Function" },
                ["]f"] = { query = "@function.outer", desc = "Function" },
                ["]]"] = { query = "@class.outer", desc = "Class" },
                ["]a"] = { query = "@parameter.inner", desc = "Parameter" },
            },
            goto_next_end = {
                ["]M"] = { query = "@function.outer", desc = "Function" },
                ["]F"] = { query = "@function.outer", desc = "Function" },
                ["]A"] = { query = "@parameter.outer", desc = "Parameter" },
            },
            goto_previous_start = {
                ["[m"] = { query = "@function.outer", desc = "Function" },
                ["[f"] = { query = "@function.outer", desc = "Function" },
                ["[["] = { query = "@class.outer", desc = "Class" },
                ["[a"] = { query = "@parameter.inner", desc = "Parameter" },
            },
            goto_previous_end = {
                ["[M"] = { query = "@function.outer", desc = "Function" },
                ["[F"] = { query = "@function.outer", desc = "Function" },
                ["[A"] = { query = "@parameter.outer", desc = "Parameter" },
                ["[L"] = { query = "@loop.outer", desc = "Loop" },
            },
        },
        select = {
            -- replaced by mini.ai
            enable = false,
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
                        ["]m"] = "@function.name",
                        ["]f"] = "@function.name",
                        ["]]"] = "@class.name",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.name",
                        ["[f"] = "@function.name",
                        ["[["] = "@class.name",
                    },
                },
            },
        })
    end,
})
