-- +---------------------------------------------------------+
-- | quolpr/quicktest.nvim: QuickTest                        |
-- +---------------------------------------------------------+

local qt = require("quicktest")
qt.setup({
    adapters = {
        require("quicktest.adapters.pytest")({}),
        require("rustaceanvim.quicktest"),
    },
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>tr", qt.run_line, { desc = "[T]est Run [R]un", })
vim.keymap.set("n", "<leader>tf", qt.run_file, { desc = "[T]est Run [F]ile", })
-- vim.keymap.set("n", "<leader>td", qt.run_dir, { desc = "[T]est Run [D]ir", })
vim.keymap.set("n", "<leader>ta", qt.run_all, { desc = "[T]est Run [A]ll", })
vim.keymap.set("n", "<leader>tR", qt.run_previous, { desc = "[T]est Run [P]revious", })
-- vim.keymap.set("n", "<leader>tt", function() qt.toggle_win("popup") end, { desc = "[T]est [T]oggle popup window", })
vim.keymap.set("n", "<leader>tt", function() qt.toggle_win("split") end, { desc = "[T]est [T]oggle Window", })
vim.keymap.set("n", "<leader>tc", function() qt.cancel_current_run() end, { desc = "[T]est [C]ancel Current Run", })
-- stylua: ignore end
