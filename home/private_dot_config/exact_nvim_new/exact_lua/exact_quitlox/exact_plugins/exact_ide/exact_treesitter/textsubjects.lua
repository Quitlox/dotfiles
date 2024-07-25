-- +---------------------------------------------------------+
-- | RRethy/nvim-treesitter-textsubjects: Smart Incremental  |
-- | Selection                                               |
-- +---------------------------------------------------------+

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    textsubjects = {
        enable = true,
        prev_selection = ",",
        keymaps = {
            ["<cr>"] = "textsubjects-smart",
            [";"] = { "textsubjects-container-outer", desc = "Select outside containers (classes, functions, etc.)" },
            ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
        },
    },
})
