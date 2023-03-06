----------------------------------------------------------------------
--                 C Family Language Configuration                  --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig = require('lspconfig')

-- Configuration
local on_attach = require("quitlox.plugins.ide.lsp.include.common").on_attach

-- C Family
local clang_capabilities = vim.lsp.protocol.make_client_capabilities()
-- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
clang_capabilities.offsetEncoding = { "utf-16" }
lspconfig.clangd.setup({
    capabilities = clang_capabilities,
    on_attach = on_attach,
})
