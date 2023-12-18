return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Module: Breadcrumbs
            { "SmiteshP/nvim-navic", lazy = true, opts = { highlight = true } },
        },
        config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    },
    {
        "j-hui/fidget.nvim",
        config = true,
    },
}
