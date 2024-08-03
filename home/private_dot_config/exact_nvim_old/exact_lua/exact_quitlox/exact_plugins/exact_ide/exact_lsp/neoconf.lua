return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            default = {
                { "<leader>vn", "Neoconf" },
            },
        },
    },
    {
        "folke/neoconf.nvim",
        version = "",
        opts = {
            import = {
                coc = false,
            },
        },
        lazy = false,
        keys = {
            { "<leader>vne", "<cmd>Neoconf<cr>", desc = "Neoconf Edit" },
            { "<leader>vns", "<cmd>Neoconf show<cr>", desc = "Neoconf Show" },
            { "<leader>vnl", "<cmd>Neoconf lsp<cr>", desc = "Neoconf Lsp" },
        },
    },
}
