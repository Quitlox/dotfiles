return {
    "RRethy/nvim-treesitter-textsubjects",
    event = "VeryLazy",
    config = function()
        require("nvim-treesitter.configs").setup({
            textsubjects = {
                enable = true,
                prev_selection = ",",
                keymaps = {
                    ["<cr>"] = "textsubjects-smart",
                    [";"] = { "textsubjects-container-outer", desc = "Select outside containers (classes, functions, etc.)" },
                    ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
                },
            },
        })
    end,
}
