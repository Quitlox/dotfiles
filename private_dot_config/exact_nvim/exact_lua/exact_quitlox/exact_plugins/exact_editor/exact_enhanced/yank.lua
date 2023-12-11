return {
    "gbprod/yanky.nvim",
    version = "",
    opts = function(_, opts)
        return {
            picker = {
                select = {
                    action = nil,
                },
                telescope = {
                    mappings = {
                        i = {
                            ["<ESC>"] = require("telescope.actions").close,
                            ["<C-BS>"] = { "<C-S-w>", type = "command" },
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-v>"] = require("telescope.actions").select_horizontal,
                            ["<C-b>"] = require("telescope.actions").select_vertical,
                        },
                    },
                },
            },
            highlight = {
                on_put = true,
                on_yank = false,
            },
        }
    end,
    keys = {
        { "p", "<Plug>(YankyPutAfter)", desc = "Yank Put After", mode = { "n", "x" } },
        { "P", "<Plug>(YankyPutBefore)", desc = "Yank Put Before", mode = { "n", "x" } },
        { "gp", "<Plug>(YankyGPutAfter)", desc = "Yank GPut After", mode = { "n", "x" } },
        { "gP", "<Plug>(YankyGPutBefore)", desc = "Yank GPut Before", mode = { "n", "x" } },
        --
        { "<c-n>", "<Plug>(YankyCycleForward)", desc = "Yank Cycle Forward" },
        { "<c-p>", "<Plug>(YankyCycleBackward)", desc = "Yank Cycle Backward" },
        --
        {
            "<leader>y",
            function()
                require("telescope").load_extension("yank_history")
                vim.cmd([[Telescope yank_history]])
            end,
            desc = "Yank History",
        },
    },
}
