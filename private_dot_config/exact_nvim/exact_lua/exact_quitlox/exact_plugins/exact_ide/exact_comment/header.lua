return {
    "LudoPinelli/comment-box.nvim",
    config = true,
    lazy = true,
    init = function()
        require("which-key").register({
            g = {
                b = {
                    b = { "<cmd>lua require('comment-box').llbox(10)<cr>", "Comment Box" },
                    l = { "<cmd>lua require('comment-box').lcline(10)<cr>", "Comment Box Line" },
                    m = { "<cmd>lua require('comment-box').catalog()<cr>", "Comment Box Catalog" },
                },
            },
        }, { mode = "n" })

        require("which-key").register({
            g = {
                b = {
                    b = { "<cmd>lua require('comment-box').llbox(10)<cr>", "Comment Box" },
                    l = { "<cmd>lua require('comment-box').lcline(10)<cr>", "Comment Box Line" },
                    m = { "<cmd>lua require('comment-box').catalog()<cr>", "Comment Box Catalog" },
                },
            },
        }, { mode = "v" })
    end,
}
