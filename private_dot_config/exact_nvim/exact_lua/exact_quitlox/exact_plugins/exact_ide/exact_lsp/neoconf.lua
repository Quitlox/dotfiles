return {
    "folke/neoconf.nvim",
    version = "",
    opts = {
        import = {
            coc = false,
        },
    },
    config = true,
    init = function()
        require("which-key").register({
            n = {
                name = "Neoconf",
                e = { "<cmd>Neoconf<cr>", "Neoconf Edit" },
                s = { "<cmd>Neoconf show<cr>", "Neoconf Show" },
                l = { "<cmd>Neoconf lsp<cr>", "Neoconf Lsp" },
            },
        }, { prefix = "<leader>v" })
    end,
}
