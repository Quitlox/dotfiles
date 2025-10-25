--+- Env: Kitty ---------------------------------------------+
if vim.env.TERM == "xterm-kitty" or vim.env.TERM == "kitty" then
    return
end

--+- Env: Neovide -------------------------------------------+
if vim.fn.exists("g:neovide") == 1 then
    vim.o.guifont = "Iosevka,Symbols Nerd Font:h11"

    vim.o.mouse = "a"
    vim.keymap.set("n", "<C-S-c>", '"+y', { noremap = true })
    vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true })
    vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true })
    vim.keymap.set("i", "<C-S-v>", "<C-r>+")

    vim.opt.clipboard = "unnamedplus"
end

--+- Env: WSL -----------------------------------------------+
if vim.fn.has("wsl") == 1 then
    -- vim.g.clipboard = "osc52"
    -- vim.g.clipboard = {
    --     name = "WslClipboard",
    --     copy = {
    --         ["+"] = "/mnt/c/Windows/System32/clip.exe",
    --         ["*"] = "/mnt/c/Windows/System32/clip.exe",
    --     },
    --     paste = {
    --         ["+"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --         ["*"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --     },
    --     cache_enabled = 0,
    -- }
end
