return {
    "mrjones2014/smart-splits.nvim",
    version = "",
    keys = {
        { "<A-h>", function() require("smart-splits").resize_left() end, desc = "which_key_ignore" },
        { "<A-j>", function() require("smart-splits").resize_down() end, desc = "which_key_ignore" },
        { "<A-k>", function() require("smart-splits").resize_up() end, desc = "which_key_ignore" },
        { "<A-l>", function() require("smart-splits").resize_right() end, desc = "which_key_ignore" },

        { "<C-Left>", function() require("smart-splits").resize_left() end, desc = "which_key_ignore" },
        { "<C-Down>", function() require("smart-splits").resize_down() end, desc = "which_key_ignore" },
        { "<C-Up>", function() require("smart-splits").resize_up() end, desc = "which_key_ignore" },
        { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "which_key_ignore" },

        { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "which_key_ignore" },
        { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "which_key_ignore" },
        { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "which_key_ignore" },
        { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "which_key_ignore" },
    },
}
