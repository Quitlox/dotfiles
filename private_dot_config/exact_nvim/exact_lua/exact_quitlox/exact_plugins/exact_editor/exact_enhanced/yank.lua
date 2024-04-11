return {
    {
        "gbprod/yanky.nvim",
        version = "",
        opts = {
            highlight = {
                on_put = true,
                on_yank = true,
            },
        },
        config = function(_, opts)
            require("yanky").setup(opts)
            -- require("telescope").load_extension("yank_history")
        end,
        keys = {
            { "p", "<Plug>(YankyPutAfter)", desc = "Yank Put After", mode = { "n", "x" } },
            { "P", "<Plug>(YankyPutBefore)", desc = "Yank Put Before", mode = { "n", "x" } },
            -- { "gp", "<Plug>(YankyGPutAfter)", desc = "Yank GPut After", mode = { "n", "x" } },
            -- { "gP", "<Plug>(YankyGPutBefore)", desc = "Yank GPut Before", mode = { "n", "x" } },
            --
            { "<c-n>", "<Plug>(YankyCycleForward)", desc = "Yank Cycle Forward" },
            { "<c-p>", "<Plug>(YankyCycleBackward)", desc = "Yank Cycle Backward" },
            --
            {
                "<leader>y",
                "<cmd>lua require('telescope').extensions.yank_history.yank_history()<cr>",
                desc = "Yank History",
            },
        },
    },
}
