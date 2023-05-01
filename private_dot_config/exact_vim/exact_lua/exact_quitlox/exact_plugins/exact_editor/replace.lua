return {
    "nvim-pack/nvim-spectre",
    init = function()
        require('which-key').register({
            R = {"<cmd>lua require('spectre').open()<CR>", "Replace"},
            r = {
                name="Replace",
                w = {"<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Replace Word"},
                f = {"<cmd>lua require('spectre').open_file_search()<CR>", "Replace in File"},
            }
        },{prefix="<leader>"})

        require('which-key').register({
                R = {"<cmd>lua require('spectre').open_visual()<CR>", "Replace Visual"},
        }, {prefix="<leader>", mode="v"})
    end
}
