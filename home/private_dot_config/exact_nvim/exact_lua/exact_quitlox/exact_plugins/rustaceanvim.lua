-- FIXME: Currently required due to cmp-nvim-lsp not supporting a specific feature of rust-analyzer.
-- Remove once issue below is resolved
-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/72
vim.g.rustaceanvim = {
    server = {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    },
}
