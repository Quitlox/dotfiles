----------------------------------------------------------------------
--                 C Family Language Configuration                  --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end

-- Configuration
local on_attach = require("quitlox.plugins.lsp.include.common").on_attach

-- C Family
local clang_capabilities = vim.lsp.protocol.make_client_capabilities()
-- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
clang_capabilities.offsetEncoding = { "utf-16" }
lspconfig.clangd.setup({
    capabilities = clang_capabilities,
    on_attach = on_attach,
})
