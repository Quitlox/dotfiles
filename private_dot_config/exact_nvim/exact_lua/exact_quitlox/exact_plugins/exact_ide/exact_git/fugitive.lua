return {
    "https://github.com/tpope/vim-fugitive",
    cond = vim.fn.executable("git") == 1,
    dependencies = { "tpope/vim-rhubarb" },
}
