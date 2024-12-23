-- Default language server settings
require("lspconfig").lua_ls.setup({
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

-- +---------------------------------------------------------+
-- | folke/lazydev.nvim: Setup Lua LSP for Neovim            |
-- +---------------------------------------------------------+

-- Setup
require("lazydev").setup({
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        -- { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
})

-- Commands
require("legendary").commands({
    { ":LazyDev", description = "Show LazyDev Settings", filters = { ft = { "lua" } } },
})
