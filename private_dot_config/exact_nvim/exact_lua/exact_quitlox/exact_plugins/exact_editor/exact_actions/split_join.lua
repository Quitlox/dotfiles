return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = {
        max_join_length = 300,
        use_default_keymaps = false,
    },
    keys = {
        { "<leader>s", "<cmd>TSJSplit<cr>", desc = "Split" },
        { "<leader>j", "<cmd>TSJJoin<cr>", desc = "Join" },
    },
}
