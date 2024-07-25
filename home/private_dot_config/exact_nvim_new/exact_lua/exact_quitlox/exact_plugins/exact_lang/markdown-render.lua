-- +---------------------------------------------------------+
-- | MeanderingProgrammer/markdown.nvim: Preview Markdown    |
-- | in Neovim                                               |
-- +---------------------------------------------------------+

require("render-markdown").setup({
    enabled = true,
    win_options = {
        concealcursor = {
            -- default = vim.api.nvim_get_option_value("concealcursor", {}),
            -- rendered = vim.api.nvim_get_option_value("concealcursor", {}),
        },
    },
})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":RenderMarkdownToggle", description = "Render Markdown in Buffer", filters = { ft = { "markdown" } } },
})
