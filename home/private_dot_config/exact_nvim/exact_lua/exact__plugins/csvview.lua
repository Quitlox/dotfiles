-- +---------------------------------------------------------+
-- | hat0uman/csvview.nvim: CSV Viewer                       |
-- +---------------------------------------------------------+

-- Setup
require("csvview").setup({})

-- Keymaps
vim.keymap.set("n", "<leader><leader>cv", "<cmd>CsvViewToggle<CR>", { noremap = true })

require("which-key").add({
    { "<leader><leader>c", group = "CSV" },
})

-- TODO: lazy load on CsvViewEnable, CsvViewDisable, CsvViewToggle
