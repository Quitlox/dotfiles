return {
    {
        "wintermute-cell/gitignore.nvim",
        cmd = "Gitignore",
        lazy = true,
    },
    require("quitlox.util").legendary({ { ":Gitignore", "Generate .gitignore file" } }),
}
