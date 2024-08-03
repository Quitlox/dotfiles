-- +---------------------------------------------------------+
-- | gbprod/yanky.nvim: Improved Yank and Put                |
-- +---------------------------------------------------------+

-- Setup
require("yanky").setup({
    highlight = {
        on_put = true,
        on_yank = true,
    },
    picker = {
        select = {
            action = nil, -- nil to use default put action
        },
        telescope = {
            mappings = nil, -- nil to use default mappings
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

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Prev Yank Entry" })
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next Yank Entry" })

vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<cr>", { desc = "Yank History" })
