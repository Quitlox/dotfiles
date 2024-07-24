-- +---------------------------------------------------------+
-- | iamcco/markdown-preview.nvim: Preview Markdown in Browser|
-- +---------------------------------------------------------+

vim.fn["mkdp#util#install"]()

--+- Keymaps ------------------------------------------------+
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "markdown",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set("n", "<localleader>mo", "<cmd>MarkdownPreview<cr>", { noremap = true, silent = true, desc = "Markdown Preview", buffer = bufnr })
        vim.keymap.set("n", "<localleader>mb", "<cmd>MarkdownPreviewStop<cr>", { noremap = true, silent = true, desc = "Markdown Preview Stop", buffer = bufnr })
        vim.keymap.set("n", "<localleader>mp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true, desc = "Markdown Preview Toggle", buffer = bufnr })
    end,
})

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
