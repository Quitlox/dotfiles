-- +---------------------------------------------------------+
-- | folke/trouble.nvim: Quickfix                            |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("trouble").setup({
    auto_preview = false,
    action_keys = {
        close = "q",
        open_split = { "<c-v>" },
        open_vsplit = { "<c-b>" },
        toggle_fold = { "zA", "za", "o" },
    },
})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":TroubleToggle", description = "Toggle Trouble" },
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>ow", "<CMD>Trouble diagnostics filter.severity={vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN}<CR>", { desc = "Open Document Diagnostics" })
vim.keymap.set("n", "<leader>od", "<CMD>Trouble diagnostics filter.severity={vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO}<CR>", {desc = "Open All Diagnostics"})
vim.keymap.set("n", "<leader>oq", "<CMD>Trouble quickfix<CR>", { desc = "Open Quickfix" })
-- stylua: ignore end
