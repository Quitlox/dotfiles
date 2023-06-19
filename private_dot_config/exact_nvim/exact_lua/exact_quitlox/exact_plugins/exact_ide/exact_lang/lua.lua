return {
    ----- LuaDev -----
    { "folke/neodev.nvim", version = "", config = false },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["lua_ls"] = function()
                    -- Developer support for Neovim configuration and Neovim plugin development
                    -- Needs to be loaded before lspconfig
                    require("neodev").setup({
                        library = { plugins = { "nvim-dap-ui" }, types = true },
                    })

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
