-- Insert Comment Frame/Header
return {
    "s1n7ax/nvim-comment-frame",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "gch", "gcH" },
    config = true,
    init=function()
        require("which-key").register({
            g = {
                c = {
                    -- TODO: Re-enable. Conflicts with Comment.nvim--[[ ? ]]
                    h = { "<cmd>lua require('nvim-comment-frame').add_comment()<cr>", "Comment Header" },
                    H = { "<cmd>lua require('nvim-comment-frame')()<cr>", "Comment Header (multi-line)" },
                },
            },
        })
    end
}
