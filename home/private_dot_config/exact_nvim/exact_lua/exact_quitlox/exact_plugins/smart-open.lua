-- +---------------------------------------------------------+
-- | danielfalk/smart-open.nvim                              |
-- +---------------------------------------------------------+

-- stylua: ignore start
require("telescope").load_extension("smart_open")
vim.keymap.set("n", "<leader>of", function() require("telescope").extensions.smart_open.smart_open(require("telescope.themes").get_dropdown({})) end, {noremap = true, silent = true, desc = "Open File"})
vim.keymap.set("n", "<leader>oa", "<cmd>Telescope find_files cwd=~<cr>", { noremap = true, silent = true, desc = "Open Any File" })
-- stylua: ignore end
