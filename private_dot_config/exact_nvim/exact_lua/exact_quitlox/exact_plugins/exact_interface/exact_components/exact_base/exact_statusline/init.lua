return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Module: Breadcrumbs
            "SmiteshP/nvim-navic",
            -- Module: yaml_schema
            -- "someone-stole-my-name/yaml-companion.nvim",
        },
        config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    },
    {
        "arkav/lualine-lsp-progress",
        event = "LspAttach",
    },
}
