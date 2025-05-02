-- +---------------------------------------------------------+
-- | Davidyz/VectorCode: Vectorize Codebases for LLMs        |
-- +---------------------------------------------------------+

require("vectorcode").setup({
    async_backend = "lsp",
    on_setup = {
        update = false, -- set to true to enable update when `setup` is called.
        lsp = false,
    },
})
