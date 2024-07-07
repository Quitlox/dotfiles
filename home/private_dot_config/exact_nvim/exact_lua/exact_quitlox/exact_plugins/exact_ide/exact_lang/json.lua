return {
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    { "b0o/SchemaStore.nvim", lazy = true },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["jsonls"] = function()
                    require('lspconfig').jsonls.setup({
                        capabilities = require('quitlox.util').make_capabilities(),
                        settings = {
                            json = {
                                schemas = require("schemastore").json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    })
                end,
            },
        },
    },
}
