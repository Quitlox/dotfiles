-- +---------------------------------------------------------+
-- | Davidyz/VectorCode: Vectorize Codebases for LLMs        |
-- +---------------------------------------------------------+

-- Only setup VectorCode if the binary is available
if vim.fn.executable("vectorcode") == 1 then
    require("vectorcode").setup({
        async_backend = "lsp",
        on_setup = {
            update = false, -- set to true to enable update when `setup` is called.
            lsp = false,
        },
    })
end
