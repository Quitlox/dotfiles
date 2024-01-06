return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Module: Breadcrumbs
            -- { "SmiteshP/nvim-navic", lazy = true, opts = { highlight = true } },
            "utilyre/barbecue.nvim",
        },
        config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    },
    {
        "utilyre/barbecue.nvim",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        init = function()
            vim.api.nvim_create_autocmd({
                "WinResized",
                "BufWinEnter",
                "CursorHold",
                "InsertLeave",
            }, {
                group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                callback = function() require("barbecue.ui").update() end,
            })

            require("legendary").commands({
                { ":Barbecue", description = "Barbecue" },
                { ":lua require('barbecue.ui').toggle(true)<cr>", description = "Show Barbecue" },
                { ":lua require('barbecue.ui').toggle(false)<cr>", description = "Hide Barbecue" },
                { ":lua require('barbecue.ui').toggle()<cr>", description = "Toggle Barbecue" },
            })
        end,
        opts = { attach_navic = false, create_autocmd = false },
    },
    {
        "j-hui/fidget.nvim",
        version = "",
        config = true,
    },
}
