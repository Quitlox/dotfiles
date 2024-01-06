return {
    "ahmedkhalf/project.nvim",
    config = function(_, opts)
        require("project_nvim").setup(opts)
        require("telescope").load_extension("projects")
    end,
    keys = {
        { "<leader>op", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Open Project" },
    },
}
