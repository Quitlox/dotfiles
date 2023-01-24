-- Require LspConfig
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end
-- Require Mason LspConfig
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then return end

-- Configuration
local capabilities = require("quitlox.plugins.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.lsp.include.common").on_attach

-- Automatic setup of all LSPs
mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    -- Manually configured servers
    ["clangd"] = function() require("quitlox.plugins.lsp.languages.c") end,
    ["jsonls"] = function() require("quitlox.plugins.lsp.languages.json") end,
    ["sumneko_lua"] = function() require("quitlox.plugins.lsp.languages.lua") end,
    ["rust_analyzer"] = function() require("quitlox.plugins.lsp.languages.rust") end,
    ["yamlls"] = function() require("quitlox.plugins.lsp.languages.yaml") end,
})
