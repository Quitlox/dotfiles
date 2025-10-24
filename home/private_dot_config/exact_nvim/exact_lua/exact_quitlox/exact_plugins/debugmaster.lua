-- +---------------------------------------------------------+
-- | miroshQa/debugmaster.nvim                               |
-- +---------------------------------------------------------+

local dm = require("debugmaster")

-- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
-- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
vim.keymap.set({ "n", "v" }, "<leader>dm", dm.mode.toggle, { nowait = true, desc = "DebugMaster: Toggle Debug Mode" })
