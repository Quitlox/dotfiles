----------------------------------------------------------------------
--                              Mason                               --
----------------------------------------------------------------------
-- Mason is a tool for easily installing third-party language-servers,
-- formatters, linters, debuggers and other utilities for Neovim.
-- Mason also takes care of automatically registering language-servers to LSP
-- and tools to NullLs.

return {
    {
        "williamboman/mason.nvim",
        config = true,
        opts = {
            ui = {
                border = "single",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {

        "williamboman/mason-lspconfig.nvim",
        -- navic used in quitlox.plugins.lsp.include.common
        dependencies = { "SmiteshP/nvim-navic" },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
            -- Attach handlers for all languages
            require("quitlox.plugins.ide.lsp.languages")
        end,
        opts = {
            automatic_installation = false,
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        keys = "<localleader>d",
        config = function(_, opts)
            require("mason-nvim-dap").setup(opts)
            require("mason-nvim-dap").setup_handlers()
        end,
        opts = {
            automatic_setup = true,
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        config = true,
        opts = {
            ensure_installed = nil,
            automatic_installation = true,
            automatic_setup = false,
        },
    },
}
