return {
    -- Adds missing highlight group
    -- { "folke/lsp-colors.nvim" },
    -- Colorscheme!
    {
        "catppuccin/nvim",
        priority = 1000,
        lazy = false,
        name = "catppucin",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    fidget = true,
                    harpoon = true,
                    leap = true,
                    lsp_saga = true,
                    mason = true,
                    neotree = true,
                    neotest = true,
                    notify = true,
                    ts_rainbow2 = true,
                    window_picker = true,
                    octo = true,
                    overseer = true,
                    which_key = true,

                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = {},
                            hints = {},
                            warnings = {},
                            information = {},
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                },
            })
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
    {
        "rachartier/tiny-devicons-auto-colors.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        config = function()
            require("tiny-devicons-auto-colors").setup()
        end,
    },
}
