-- +---------------------------------------------------------+
-- | danielfalk/smart-open.nvim                              |
-- +---------------------------------------------------------+

local config = {
    cwd_only = true,
    match_algorithm = "fzy",
    ignore_patterns = { "*.git/*", "*/tmp/*", ".venv/*" },
}
config = vim.tbl_extend("keep", config, require("telescope.themes").get_dropdown({}))

-- stylua: ignore start
require("telescope").load_extension("smart_open")
vim.keymap.set("n", "<leader>of", function() 
    config.cwd  = vim.fn.getcwd(-1, 0)
    require("telescope").extensions.smart_open.smart_open(config)
end, {noremap = true, silent = true, desc = "Open File"})
vim.keymap.set("n", "<leader>oa", "<cmd>Telescope find_files cwd=~<cr>", { noremap = true, silent = true, desc = "Open Any File" })
-- stylua: ignore end
