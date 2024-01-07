return {
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = "Gitignore",
        lazy = true,
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = require("quitlox.util").legendary({ { ":Gitignore", "Generate .gitignore file" } }),
    },
}
