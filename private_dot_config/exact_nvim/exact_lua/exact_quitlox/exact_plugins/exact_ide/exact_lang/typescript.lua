return {
    -- FIXME: Replace with new typescript-tools.nvim
    -- https://github.com/pmizio/typescript-tools.nvim
    -- Blocked by: https://github.com/pmizio/typescript-tools.nvim/issues/36

    ----- Typescript -----
    { "jose-elias-alvarez/typescript.nvim", lazy = false },
    {
        "dmmulroy/tsc.nvim",
        cmd = "TSC",
        config = true,
        version = "",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["tsserver"] = function()
                    local typescript_capabilities = require("quitlox.util").make_capabilities()
                    typescript_capabilities.documentFormattingProvider = false

                    require("typescript").setup({
                        server = {
                            capabilities = typescript_capabilities,
                        },
                    })
                end,
            },
        },
    },
}
