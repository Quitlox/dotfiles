return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            default = {
                { "<localleader>m", group = "Markdown" },
            },
        },
    },
    -- Preview Markdown file in Browser
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        keys = {
            { "<localleader>mo", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
            { "<localleader>mb", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
            { "<localleader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
        },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    -- Preview Markdown file in Neovim
    {
        "MeanderingProgrammer/markdown.nvim",
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            { "<localleader>mr", "<cmd>RenderMarkdownToggle<cr>", desc = "Toggle in-line preview" },
        },
        ft = "markdown",
        opts = {
            start_enabled = false,
            win_options = {
                concealcursor = {
                    default = vim.api.nvim_get_option_value("concealcursor", {}),
                    -- rendered = vim.api.nvim_get_option_value("concealcursor", {}),
                },
            },
        },
        config = function(_, opts)
            require("render-markdown").setup(opts)
        end,
    },
    require("quitlox.util").legendary({ { ":RenderMarkdownToggle", "Render Markdown in Buffer" } }),
}
