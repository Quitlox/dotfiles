return {
    ----- LuaDev -----
    -- { "folke/neodev.nvim", version = "", config = false },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = require("quitlox.util").make_capabilities(),
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = "Replace",
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
            },
        },
    },
}
