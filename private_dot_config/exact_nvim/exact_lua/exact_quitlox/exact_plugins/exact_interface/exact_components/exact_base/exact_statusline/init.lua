return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Module: Breadcrumbs
            "SmiteshP/nvim-navic",
            --
            "linrongbin16/lsp-progress.nvim",
        },
        config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    },
    {
        "linrongbin16/lsp-progress.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("lsp-progress").setup() end,
    },
}
