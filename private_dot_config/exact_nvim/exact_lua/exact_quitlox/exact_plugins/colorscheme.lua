return {
    "catppuccin/nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("catppuccin").setup({
            integrations = {
                gitsigns = true,
                harpoon = true,
                hop = true,
                leap = true,
                lsp_saga = true,
                markdown = true,
                mason = true,
                mini = true,
                neotree = true,
                neogit = true,
                neotest = true,
                cmp = true,
                dap = {
                    enabled = true,
                    enable_ui = true,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = {  },
                        hints = {  },
                        warnings = {  },
                        information = {  },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                navic = {
                    enabled = true,
                    custom_bg = "NONE",
                },
                notify = true,
                treesitter = true,
                ts_rainbow2 = true,
                symbols_outline = true,
                telescope = true,
                lsp_trouble = true,
                illuminate = true,
                which_key = true,
            },
        })
        vim.cmd([[colorscheme catppuccin]])
    end,
}
