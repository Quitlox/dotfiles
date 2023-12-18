return {
    {
        -- For some reason does not allow me to do actions on the containers or images
        "lpoto/telescope-docker.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
        enabled = false,
        config = function()
            require("telescope").load_extension("docker")
        end,
        keys = {
            { "<localleader>odc", "<cmd>Telescope docker containers<cr>", desc = "Open Docker Containers" },
            { "<localleader>odi", "<cmd>Telescope docker images<cr>", desc = "Open Docker Images" },
            { "<localleader>odn", "<cmd>Telescope docker networks<cr>", desc = "Open Docker Networks" },
            { "<localleader>odv", "<cmd>Telescope docker volumes<cr>", desc = "Open Docker Volumes" },
        },
    },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>o"] = { name = "Open" },
                ["<localleader>od"] = { name = "Docker" },
            },
        },
    },
}
