return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    config = function()
        require("treesj").setup({
            use_default_keymaps = false,
        })
    end,
    keys = {
        { "<leader>s", "<cmd>TSJSplit<cr>", desc = "Split" },
        { "<leader>j", "<cmd>TSJJoin<cr>", desc = "Join" },
    },
}
