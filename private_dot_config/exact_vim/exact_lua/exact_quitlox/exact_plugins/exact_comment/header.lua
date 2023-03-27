-- Insert Comment Frame/Header
-- return {
--     "s1n7ax/nvim-comment-frame",
--     dependencies = { "nvim-treesitter/nvim-treesitter" },
--     keys = { "gch", "gcH" },
--     config = true,
--     init=function()
--         require("which-key").register({
--             g = {
--                 c = {
--                     -- TODO: Re-enable. Conflicts with Comment.nvim--[[ ? ]]
--                     h = { "<cmd>lua require('nvim-comment-frame').add_comment()<cr>", "Comment Header" },
--                     H = { "<cmd>lua require('nvim-comment-frame')()<cr>", "Comment Header (multi-line)" },
--                 },
--             },
--         })
--     end
-- }

return {
    "LudoPinelli/comment-box.nvim",
    config = true,
    init = function()
        require("quitlox.util.which_key").register({
            g = {
                b = {
                    b = { "<cmd>lua require('comment-box').llbox(10)<cr>", "Comment Box" },
                    c = { "<cmd>lua require('comment-box').accbox(10)<cr>", "Comment Box Centered" },
                    l = { "<cmd>lua require('comment-box').lcline(10)<cr>", "Comment Box Line" },
                    m = { "<cmd>lua require('comment-box').catalog()<cr>", "Comment Box Catalog" },
                },
            },
        }, {mode = "n"})
         
        require("quitlox.util.which_key").register({
            g = {
                b = {
                    b = { "<cmd>lua require('comment-box').llbox(10)<cr>", "Comment Box" },
                    c = { "<cmd>lua require('comment-box').accbox(10)<cr>", "Comment Box Centered" },
                    l = { "<cmd>lua require('comment-box').lcline(10)<cr>", "Comment Box Line" },
                    m = { "<cmd>lua require('comment-box').catalog()<cr>", "Comment Box Catalog" },
                },
            },
        }, {mode = "v"})
    end
}
