return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            -- Module: Breadcrumbs
            "SmiteshP/nvim-navic",
            -- Module: yaml_schema
            -- "someone-stole-my-name/yaml-companion.nvim",
        },
        config = function() require("quitlox.plugins.ui.components.statusline.lualine") end,
    },
    {
        "arkav/lualine-lsp-progress",
    },
}
