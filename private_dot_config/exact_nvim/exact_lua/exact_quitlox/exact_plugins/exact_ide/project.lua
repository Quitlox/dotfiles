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
    keys = {
        {
            "<leader>op",
            vim.schedule_wrap(function() require("telescope").extensions.projects.projects({}) end),
        },
    },
}
