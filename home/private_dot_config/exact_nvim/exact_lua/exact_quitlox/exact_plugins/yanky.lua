-- +---------------------------------------------------------+
-- | gbprod/yanky.nvim: Improved Yank and Put                |
-- +---------------------------------------------------------+

-- Setup
require("yanky").setup({
    preserve_cursor_position = {
        enabled = true,
    },
    highlight = {
        on_put = true,
        on_yank = true,
    },
    picker = {
        telescope = {
            use_default_mappings = true,
            mappings = {
                i = {
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                },
            },
        },
    },
})

-- Telescope
require("telescope").load_extension("yank_history")

-- Keymaps
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put (After)" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put (Before)" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "PutG (After)" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "PutG (Before)" })

vim.keymap.set("n", "<c-p>", "<Plug>(YankyNextEntry)", { desc = "Prev Yank Entry" })
vim.keymap.set("n", "<c-n>", "<Plug>(YankyPreviousEntry)", { desc = "Next Yank Entry" })

vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<cr>", { desc = "Yank History" })
