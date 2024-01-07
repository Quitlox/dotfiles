return {
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = "Gitignore",
        lazy = true,
    },
    require("quitlox.util").legendary({ { ":Gitignore", "Generate .gitignore file" } }),
}
