return {
    "LudoPinelli/comment-box.nvim",
    config = true,
    keys = {
        { "gbb", function() require("comment-box").llbox(10) end, desc = "Comment Box", mode = { "n", "v" } },
        { "gbl", function() require("comment-box").lcline(10) end, desc = "Comment Box Line", mode = { "n", "v" } },
        { "gbm", function() require("comment-box").catalog() end, desc = "Comment Box Catalog", mode = { "n", "v" } },
    },
}
