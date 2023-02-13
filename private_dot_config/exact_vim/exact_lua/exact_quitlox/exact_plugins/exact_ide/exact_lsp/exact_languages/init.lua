-- Require LspConfig
local lspconfig = require("lspconfig")
-- Require Mason LspConfig
local mason_lspconfig = require("mason-lspconfig")

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
    ["clangd"] = function() require("quitlox.plugins.ide.lsp.languages.c") end,
    ["jsonls"] = function() require("quitlox.plugins.ide.lsp.languages.json") end,
    ["sumneko_lua"] = function() require("quitlox.plugins.ide.lsp.languages.lua") end,
    -- NOTE: Thanks to rust_analyzer, lazy loading DAP and all related plugins
    -- is not possible
    ["rust_analyzer"] = function() require("quitlox.plugins.ide.lsp.languages.rust") end,
    ["yamlls"] = function() require("quitlox.plugins.ide.lsp.languages.yaml") end,
    ["tsserver"] = function() require("quitlox.plugins.ide.lsp.languages.typescript") end,
})

-- Custom Language specific code
require("quitlox.plugins.ide.lsp.languages.python")
