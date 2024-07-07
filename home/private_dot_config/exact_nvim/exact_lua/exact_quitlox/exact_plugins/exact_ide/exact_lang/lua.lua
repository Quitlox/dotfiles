return {
    ----- LuaDev -----
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    { -- optional completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
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
