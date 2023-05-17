return {
    "crusj/bookmarks.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons" },
    config = function()
        require("bookmarks").setup()
        require("telescope").load_extension("bookmarks")
    end,
    init = function()
        require("which-key").register({
            l = {
                b = { "<cmd>Telescope bookmarks<cr>", "Bookmarks" },
            },
        }, { prefix = "<leader>" })
    end,
}
