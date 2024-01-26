return {
    "ahmedkhalf/project.nvim",
    opts = {
        patterns = { "stylua.toml", ".stylua.toml", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
    },
    config = function(_, opts)
        require("project_nvim").setup(opts)
        require("telescope").load_extension("projects")
    end,
    -- FIXME: https://github.com/ahmedkhalf/project.nvim/issues/123
    lazy = false,
    keys = {
        {
            "<leader>op",
            "<cmd>lua require('telescope').extensions.projects.projects({})<cr>",
        },
    },
}
