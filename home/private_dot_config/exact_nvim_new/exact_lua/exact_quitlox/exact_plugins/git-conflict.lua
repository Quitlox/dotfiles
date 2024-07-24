-- +---------------------------------------------------------+
-- | akinsho/git-conflict.nvim: Git Conflicts                |
-- +---------------------------------------------------------+

-- Setup
require("git-conflict").setup({
    default_mappings = false,
    default_command = true,
})

-- Keympas
vim.keymap.set("n", "<leader>xo", "<Plug>(git-conflict-ours)", { noremap = false, silent = true, desc = "Choose ours" })
vim.keymap.set("n", "<leader>xt", "<Plug>(git-conflict-theirs)", { noremap = false, silent = true, desc = "Choose theirs" })
vim.keymap.set("n", "<leader>xb", "<Plug>(git-conflict-both)", { noremap = false, silent = true, desc = "Choose both" })
vim.keymap.set("n", "<leader>x0", "<Plug>(git-conflict-none)", { noremap = false, silent = true, desc = "Choose none" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { noremap = false, silent = true, desc = "Next conflict" })
vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { noremap = false, silent = true, desc = "Previous conflict" })

-- Whichkey
require("which-key").add({
    { "<leader>x", group = "Conflict" },
})
