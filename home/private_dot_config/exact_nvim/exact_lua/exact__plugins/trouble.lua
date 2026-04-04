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
    icons = {
        indent = {
            fold_open = "  ",
            fold_closed = "  ",
            ws = "  ",
        },
        -- codicons
        folder_closed = " ",
        folder_open = " ",
        kinds = require("_config.util.codicons").kinds,
    },
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>ow", "<CMD>Trouble diagnostics filter.not={ [\"item.source\"] = \"Harper\" } focus=true<CR>", { desc = "Open Document Diagnostics" })
vim.keymap.set("n", "<leader>od", "<CMD>Trouble diagnostics filter.not={ [\"item.source\"] = \"Harper\" } focus=true<CR>", {desc = "Open All Diagnostics"})
vim.keymap.set("n", "<leader>oq", "<CMD>Trouble quickfix<CR>", { desc = "Open Quickfix" })
-- stylua: ignore end
