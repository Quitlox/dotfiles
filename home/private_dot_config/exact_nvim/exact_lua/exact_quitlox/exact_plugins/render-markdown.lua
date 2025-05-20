-- +---------------------------------------------------------+
-- | MeanderingProgrammer/render-markdown.nvim: Preview      |
-- | Markdown in Neovim                                      |
-- +---------------------------------------------------------+

require("render-markdown").setup({
    enabled = true,
    render_modes = { "n", "c", "t" }, -- Render in normal, command, and terminal modes
    max_file_size = 10.0, -- Maximum file size in MB to render
    file_types = { "markdown", "codecompanion" },
})

-- Keymaps for toggling markdown rendering
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown Rendering", buffer = 0 })
    end,
})