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
        select = {},
    },
})

-- Keymaps
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put (After)" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put (Before)" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "PutG (After)" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "PutG (Before)" })

vim.keymap.set("n", "<c-p>", "<Plug>(YankyNextEntry)", { desc = "Prev Yank Entry" })
vim.keymap.set("n", "<c-n>", "<Plug>(YankyPreviousEntry)", { desc = "Next Yank Entry" })

vim.keymap.set("n", "<leader>y", "<cmd>YankyRingHistory<cr>", { desc = "Yank History" })
