return {
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["gopls"] = function()
                    require("lspconfig").gopls.setup({
                        capabilities = require("quitlox.util").make_capabilities(),
                    })
                end,
            },
        },
    },
}
