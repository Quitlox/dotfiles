-- +---------------------------------------------------------+
-- | iamcco/markdown-preview.nvim: Preview Markdown in Browser|
-- +---------------------------------------------------------+

--+- Keymaps ------------------------------------------------+
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "markdown",
    callback = function()
        vim.fn["mkdp#util#install"]()

        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set("n", "<localleader>mo", "<cmd>MarkdownPreview<cr>", { noremap = true, silent = true, desc = "Markdown Preview", buffer = bufnr })
        vim.keymap.set("n", "<localleader>mb", "<cmd>MarkdownPreviewStop<cr>", { noremap = true, silent = true, desc = "Markdown Preview Stop", buffer = bufnr })
        vim.keymap.set("n", "<localleader>mp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true, desc = "Markdown Preview Toggle", buffer = bufnr })
    end,
})
