return {
    "https://github.com/tpope/vim-fugitive",
    nabled = vim.fn.executable("git") == 1,
    dependencies = { "tpope/vim-rhubarb" },
}
