if vim.fn.exists("g:neovide") == 0 then
    return
end

vim.o.guifont = "Iosevka:h11"
-- vim.g.neovide_window_blurred = true

vim.o.mouse = "a"
vim.keymap.set("n", "<C-S-c>", '"+y', { noremap = true })
vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true })
vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true })
vim.keymap.set("i", "<C-S-v>", "<C-r>+")

vim.notify("Running with neovide", "info")
