return {
    "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(opts)
        require("yanky").setup({
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
        })
        require("telescope").load_extension("yank_history")
    end,
    init = function()
        local wk = require("which-key")

        wk.register({
            ["p"] = { "<Plug>(YankyPutAfter)", "Yank Put After" },
            ["P"] = { "<Plug>(YankyPutBefore)", "Yank Put Before" },
            ["gp"] = { "<Plug>(YankyGPutAfter)", "Yank GPut After" },
            ["gP"] = { "<Plug>(YankyGPutBefore)", "Yank GPut Before" },
        }, { mode = "n" })

        wk.register({
            ["p"] = { "<Plug>(YankyPutAfter)", "Yank Put After" },
            ["P"] = { "<Plug>(YankyPutBefore)", "Yank Put Before" },
            ["gp"] = { "<Plug>(YankyGPutAfter)", "Yank GPut After" },
            ["gP"] = { "<Plug>(YankyGPutBefore)", "Yank GPut Before" },
        }, { mode = "x" })

        wk.register({
            ["<c-n>"] = { "<Plug>(YankyCycleForward)", "Yank Cycle Forward" },
            ["<c-p>"] = { "<Plug>(YankyCycleBackward)", "Yank Cycle Backward" },
        }, { mode = "n" })

        wk.register({
            y = { ":Telescope yank_history<cr>", "Yank History" },
        }, { prefix = "<leader>" })
    end,
}
