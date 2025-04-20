if vim.fn.has("wsl") == 0 then
    return
end

--+- Clipboard ----------------------------------------------+
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
