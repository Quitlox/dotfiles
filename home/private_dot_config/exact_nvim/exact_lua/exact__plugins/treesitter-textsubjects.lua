-- +---------------------------------------------------------+
-- | RRethy/nvim-treesitter-textsubjects: Smart Incremental  |
-- | Selection                                               |
-- +---------------------------------------------------------+

require("nvim-treesitter-textsubjects").configure({
    -- prev_selection = ",",
    prev_selection = "<bs>",
    keymaps = {
        -- ["."] = "textsubjects-smart",
        ["<cr>"] = "textsubjects-smart",
        -- [";"] = "textsubjects-container-outer", -- FIXME: conflict with flash
        -- ["i;"] = "textsubjects-container-inner",
    },
})

require("which-key").add({
    -- { ".", desc = "Smart Select", mode = "v" },
    { "<cr>", desc = "Smart Select", mode = "v" },
    -- { ";", desc = "Select outside containers", mode = "v" },
    -- { "i;", desc = "Select inside containers", mode = "v" },
})
