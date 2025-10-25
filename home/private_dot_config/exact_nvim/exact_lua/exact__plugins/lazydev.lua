-- +---------------------------------------------------------+
-- | folke/lazydev.nvim: Setup Lua LSP for Neovim            |
-- +---------------------------------------------------------+

require("lazydev").setup({
    library = {
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- Only load the lazyvim library when the `LazyVim` global is found
        { path = "LazyVim", words = { "LazyVim" } },
    },
    integrations = {
        cmp = false,
    },
})

Snacks.toggle
    .new({
        name = "LazyDev",
        get = function()
            return vim.g.lazydev_enabled
        end,
        set = function(state)
            vim.g.lazydev_enabled = state
        end,
    })
    :map("yol")
