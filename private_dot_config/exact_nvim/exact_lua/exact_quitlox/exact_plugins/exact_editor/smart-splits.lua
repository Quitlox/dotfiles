return {
    "mrjones2014/smart-splits.nvim",
    version = "",
    keys = {
        { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize Left" },
        { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize Down" },
        { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize Up" },
        { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize Right" },

        { "<C-Left>", function() require("smart-splits").resize_left() end, desc = "Resize Left" },
        { "<C-Down>", function() require("smart-splits").resize_down() end, desc = "Resize Down" },
        { "<C-Up>", function() require("smart-splits").resize_up() end, desc = "Resize Up" },
        { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Resize Right" },

        { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move Cursor Left" },
        { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move Cursor Down" },
        { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move Cursor Up" },
        { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move Cursor Right" },
    },
}
