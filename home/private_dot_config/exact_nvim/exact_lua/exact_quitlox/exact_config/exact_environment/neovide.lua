if vim.fn.exists("g:neovide") == 0 then
    return
end

vim.o.guifont = "Iosevka,Symbols Nerd Font:h11"

vim.o.mouse = "a"
vim.keymap.set("n", "<C-S-c>", '"+y', { noremap = true })
vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true })
vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true })
vim.keymap.set("i", "<C-S-v>", "<C-r>+")

--+- Clipboard ----------------------------------------------+
vim.opt.clipboard = "unnamedplus"
