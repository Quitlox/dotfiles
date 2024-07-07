return {
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["clangd"] = function()
                    -- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
                    local clang_capabilities = require("quitlox.util").make_capabilities()
                    clang_capabilities.offsetEncoding = { "utf-16" }

                    require("lspconfig").clangd.setup({
                        capabilities = clang_capabilities,
                    })
                end,
            },
        },
    },
}
