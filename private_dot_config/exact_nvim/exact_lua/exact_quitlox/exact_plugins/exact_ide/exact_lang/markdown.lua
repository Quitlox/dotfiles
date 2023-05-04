return {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
        require("which-key").register({
            m = {
                name = "Markdown",
                ["o"] = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
                ["b"] = { "<cmd>MarkdownPreviewStop<cr>", "Markdown Preview Stop" },
                ["p"] = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown Preview Toggle" },
            },
        }, { prefix = "<localleader>" })
    end,
}
