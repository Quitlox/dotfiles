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
            ["."] = "textsubjects-smart",
            -- [";"] = "textsubjects-container-outer", -- FIXME: conflict with flash
            -- ["i;"] = "textsubjects-container-inner",
        },
    },
})

require("which-key").add({
    { ".", desc = "Smart Select", mode = "v" },
    -- { ";", desc = "Select outside containers", mode = "v" },
    -- { "i;", desc = "Select inside containers", mode = "v" },
})
