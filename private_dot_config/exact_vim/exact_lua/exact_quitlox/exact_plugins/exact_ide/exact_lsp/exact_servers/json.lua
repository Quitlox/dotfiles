----------------------------------------------------------------------
--                   JSON Language Configuration                    --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig = require('lspconfig')
-- Schemastore
local schemastore = require("schemastore")

-- Configuration
local capabilities = require("quitlox.plugins.ide.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.ide.lsp.include.common").on_attach

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
