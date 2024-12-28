-- +---------------------------------------------------------+
-- | ofirgall/goto-breakpoints.nvim: Navigate Breakpoints    |
-- +---------------------------------------------------------+
vim.keymap.set("n", "[b", function()
    require("goto-breakpoints").prev()
end, { noremap = true, silent = true, desc = "Previous Breakpoint" })
vim.keymap.set("n", "]b", function()
    require("goto-breakpoints").next()
end, { noremap = true, silent = true, desc = "Next Breakpoint" })
