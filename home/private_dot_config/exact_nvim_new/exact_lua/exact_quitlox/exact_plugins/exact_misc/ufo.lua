local opts = {
    provider_selector = { "treesitter", "indent" },
}

vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

require("ufo").setup(opts)
