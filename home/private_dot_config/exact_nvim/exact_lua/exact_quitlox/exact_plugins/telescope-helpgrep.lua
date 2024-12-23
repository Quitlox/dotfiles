-- +---------------------------------------------------------+
-- | catgoose/telescope-helpgrep.nvim                        |
-- +---------------------------------------------------------+

require("telescope").load_extension("helpgrep")
vim.keymap.set("n", "<leader>fh", function()
    require("telescope-helpgrep").live_grep(require("telescope.themes").get_dropdown({}))
end, { noremap = true, silent = true, desc = "Find Help" })
