return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>m"] = "Markdown",
            },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        keys = {
            { "<localleader>mo", "<cmd>MarkdownPreview<cr>",       desc = "Markdown Preview" },
            { "<localleader>mb", "<cmd>MarkdownPreviewStop<cr>",   desc = "Markdown Preview Stop" },
            { "<localleader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
        },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
}
