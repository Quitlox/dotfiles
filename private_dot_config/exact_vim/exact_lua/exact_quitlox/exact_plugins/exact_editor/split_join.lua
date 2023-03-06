return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "TSJToggle",
    keys= { "<C-s>" },
    config = function()
        require("treesj").setup({

            use_default_keymaps = false,
        })
    end,
    init = function()
        require('quitlox.util.which_key').register({
            ["<C-s>"] = { "<cmd>TSJToggle<cr>", "Toggle Split/Join" },
        })
    end,
}
