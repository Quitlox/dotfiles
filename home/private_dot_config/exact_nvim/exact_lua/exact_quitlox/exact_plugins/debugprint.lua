-- +---------------------------------------------------------+
-- | andrewferrier/debugprint.nvim:                          |
-- |     Debugging in NeoVim the print() way!                |
-- +---------------------------------------------------------+

require("debugprint").setup({
    move_to_debugline = false,
    display_lcoation = true,
    display_counter = true,
    display_snippet = true,
    notify_for_registers = true,
    highlight_lines = true,
    print_tag = "DEBUGPRINT",

    keymaps = {
        normal = {
            plain_below = "g?p",
            plain_above = "g?P",
            variable_below = "g?v",
            variable_above = "g?V",
            variable_below_alwaysprompt = "",
            variable_above_alwaysprompt = "",
            surround_plain = "g?sp",
            surround_variable = "g?sv",
            surround_variable_alwaysprompt = "",
            textobj_below = "g?o",
            textobj_above = "g?O",
            textobj_surround = "g?so",
            toggle_comment_debug_prints = "",
            delete_debug_prints = "",
        },
        insert = {
            plain = "<C-G>p",
            variable = "<C-G>v",
        },
        visual = {
            variable_below = "g?v",
            variable_above = "g?V",
        },
    },
})

require("which-key").add({
    { "g?", group = "Debug Print" },

    { "g?o", desc = "Debug Print Text Object Below" },
    { "g?O", desc = "Debug Print Text Object Above" },
    { "g?p", desc = "Debug Print Below" },
    { "g?P", desc = "Debug Print Above" },
    { "g?v", desc = "Debug Print Variable Below" },
    { "g?V", desc = "Debug Print Variable Above" },

    { "g?so", desc = "Debug Print Surround Text Object" },
    { "g?sp", desc = "Debug Print Surround Below" },
    { "g?sv", desc = "Debug Print Surround Variable Below" },

    { "<C-G>p", desc = "Debug Print Insert Plain" },
    { "<C-G>v", desc = "Debug Print Insert Variable" },
})
