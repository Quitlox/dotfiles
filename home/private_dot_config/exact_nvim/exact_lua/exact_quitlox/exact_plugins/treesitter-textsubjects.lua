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
    { "<cr>", desc = "Select more" },
    { ";", desc = "Select outside containers", mode = "v" },
    { "i;", desc = "Select inside containers", mode = "v" },
})
