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
                ["]m"] = { query = "@function.outer", desc = "Next Function" },
                ["]]"] = { query = "@class.outer", desc = "Next Class" },
                ["]a"] = { query = "@parameter.inner", desc = "Next Parameter" },
            },
            goto_next_end = {
                ["]M"] = { query = "@function.outer", desc = "Next Function" },
                ["]A"] = { query = "@parameter.outer", desc = "Next Parameter" },
            },
            goto_previous_start = {
                ["[m"] = { query = "@function.outer", desc = "Prev Function" },
                ["[["] = { query = "@class.outer", desc = "Prev Class" },
                ["[a"] = { query = "@parameter.inner", desc = "Prev Parameter" },
            },
            goto_previous_end = {
                ["[M"] = { query = "@function.outer", desc = "Prev Function" },
                ["[A"] = { query = "@parameter.outer", desc = "Prev Parameter" },
                ["[L"] = { query = "@loop.outer", desc = "Prev Loop" },
            },
        },
        select = {
            -- replaced by mini.ai
            enable = false,
        },
        swap = {
            enable = true,
            swap_next = {
                [">a"] = { query = "@parameter.inner", desc = "Swap Next" },
            },
            swap_previous = {
                ["<a"] = { query = "@parameter.inner", desc = "Swap Previous" },
            },
        },
    },
})

-- NOTE: Filetype specific textobjects currently configured in:
-- - ftplugin/python.lua
