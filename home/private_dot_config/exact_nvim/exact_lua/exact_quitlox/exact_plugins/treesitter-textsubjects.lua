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
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
        },
    },
})

require("which-key").add({
    { "<cr>", "Select more" },
    { ";", "Select outside containers", mode = "v" },
    { "i;", "Select inside containers", mode = "v" },
})
