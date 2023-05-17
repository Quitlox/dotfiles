return {
    "nvim-pack/nvim-spectre",
    init = function()
        require("which-key").register({
            r = {
                name = "Replace",
                r = { "<cmd>lua require('spectre').open()<CR>", "Replace" },
                w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Replace Word" },
                f = { "<cmd>lua require('spectre').open_file_search()<CR>", "Replace in File" },
            },
        }, { prefix = "<leader>" })
        require("which-key").register({
            R = { "<cmd>lua require('spectre').open_visual()<CR>", "Replace Visual" },
        }, { prefix = "<leader>", mode = "v" })

        require("legendary").command({
            ":Replace",
            "<cmd>lua require('spectre').open()<CR>",
            description = "Replace word under cursor in project",
        })
        require("legendary").command({
            ":ReplaceWord",
            "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
            description = "Replace word under cursor in project",
        })
        require("legendary").command({
            ":ReplaceFile",
            "<cmd>lua require('spectre').open_file_search()<CR>",
            description = "Replace in file",
        })
        require("legendary").command({
            ":ReplaceVisual",
            "<cmd>lua require('spectre').open_visual()<CR>",
            description = "Replace visual selection",
        })
    end,
}
