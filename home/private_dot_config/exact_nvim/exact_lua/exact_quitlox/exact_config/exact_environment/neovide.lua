if vim.fn.exists("g:neovide") == 0 then
    return
end

vim.o.guifont = "Iosevka:h11"

vim.o.mouse = "a"
vim.keymap.set("n", "<C-S-c>", '"+y', { noremap = true })
vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true })
vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true })
vim.keymap.set("i", "<C-S-v>", "<C-r>+")

--+- Clipboard ----------------------------------------------+
local function neovide_rpc(method, ...)
    return vim.rpcrequest(vim.g.neovide_channel_id, method, ...)
end

local function neovide_copy(lines)
    return neovide_rpc("neovide.set_clipboard", lines)
end

local function neovide_paste()
    return neovide_rpc("neovide.get_clipboard")
end

vim.g.clipboard = {
    name = "neovide",
    copy = {
        ["+"] = neovide_copy,
        ["*"] = neovide_copy,
    },
    paste = {
        ["+"] = neovide_paste,
        ["*"] = neovide_paste,
    },
    cache_enabled = 0,
}
