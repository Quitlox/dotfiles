return {
    "andrewferrier/wrapping.nvim",
    config=true,
    init=function()
        require('which-key').register({
            w = {
                name = "Wrap mode",
                h = {"<cmd>HardWrapMode<cr>", "Hard wrap"},
                s = {"<cmd>HardWrapMode<cr>", "Soft wrap"},
                t = {"<cmd>HardWrapMode<cr>", "Toggle wrap"},
            }
        }, {prefix="<leader>T"})
    end
}
