-- +---------------------------------------------------------+
-- | ofirgall/goto-breakpoints.nvim: Navigate Breakpoints    |
-- +---------------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "[B", function() require("goto-breakpoints").prev() end, { noremap = true, silent = true, desc = "Previous Breakpoint" })
vim.keymap.set("n", "]B", function() require("goto-breakpoints").next() end, { noremap = true, silent = true, desc = "Next Breakpoint" })
-- stylua: ignore end
