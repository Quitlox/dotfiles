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
        init = function()
            require("quitlox.util.which_key").register({
                m = { "<cmd>Mason<cr>", "Mason" },
            }, { prefix = "<leader>v" })
        end,
    },
    {

        "williamboman/mason-lspconfig.nvim",
        -- navic used in quitlox.plugins.lsp.include.common
        dependencies = { "SmiteshP/nvim-navic" },
        config = function(_, opts)
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup(opts)

            -- Attach handlers for all languages

            -- Require LspConfig
            local lspconfig = require("lspconfig")

            -- Configuration
            local capabilities = require("quitlox.plugins.ide.lsp.include.common").capabilities
            local on_attach = require("quitlox.plugins.ide.lsp.include.common").on_attach

            -- Automatic setup of all LSPs
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                -- Manually configured servers
                ["clangd"] = function() require("quitlox.plugins.ide.lsp.servers.c") end,
                ["jsonls"] = function() require("quitlox.plugins.ide.lsp.servers.json") end,
                ["lua_ls"] = function() require("quitlox.plugins.ide.lsp.servers.lua") end,
                -- NOTE: Thanks to rust_analyzer, lazy loading DAP and all related plugins
                -- is not possible
                ["rust_analyzer"] = function() require("quitlox.plugins.ide.lsp.servers.rust") end,
                ["yamlls"] = function() require("quitlox.plugins.ide.lsp.servers.yaml") end,
                ["tsserver"] = function() require("quitlox.plugins.ide.lsp.servers.typescript") end,
            })

            -- Custom Language specific code
            require("quitlox.plugins.ide.lsp.include.python")
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
            automatic_installation = false,
            automatic_setup = false,
        },
    },
}
