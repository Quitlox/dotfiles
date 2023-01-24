----------------------------------------------------------------------
--                   JSON Language Configuration                    --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end
-- Schemastore
local schemastore_ok, schemastore = pcall(require, "schemastore")
if not schemastore_ok then return end

-- Configuration
local capabilities = require("quitlox.plugins.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.lsp.include.common").on_attach

lspconfig.jsonls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
        },
    },
})
