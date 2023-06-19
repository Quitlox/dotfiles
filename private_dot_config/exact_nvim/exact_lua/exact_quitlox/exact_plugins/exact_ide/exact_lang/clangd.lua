return {
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["clangd"] = function()
                    -- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
                    local clang_capabilities = capabilities
                    clang_capabilities.offsetEncoding = { "utf-16" }

                    lspconfig.clangd.setup({
                        capabilities = clang_capabilities,
                        on_attach = on_attach,
                    })
                end,
            },
        },
    },
}
