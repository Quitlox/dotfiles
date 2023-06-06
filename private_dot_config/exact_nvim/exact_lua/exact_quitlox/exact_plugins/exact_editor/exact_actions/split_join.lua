return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "TSJToggle",
    keys= { "<leader>s", "<leader>j"  },
    config = function()
        require("treesj").setup({
            use_default_keymaps = false,
        })
    end,
    init = function()
        require('which-key').register({
            -- ["<leader>m"] = { "<cmd>TSJToggle<cr>", "Toggle Split/Join" },
            ["<leader>s"] = { "<cmd>TSJSplit<cr>", "Toggle Split/Join" },
            ["<leader>j"] = { "<cmd>TSJJoin<cr>", "Toggle Split/Join" },
        })
    end,
}
