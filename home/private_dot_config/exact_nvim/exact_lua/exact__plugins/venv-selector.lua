-- +---------------------------------------------------------+
-- | linux-cultist/venv-selector.nvim: Python Venv           |
-- +---------------------------------------------------------+

if not (vim.fn.executable("fd") == 1 or vim.fn.executable("fdfind") == 1) then
    vim.notify("venv-selector: 'fd' or 'fdfind' is required but not found in PATH.", vim.log.levels.WARN)
end

require("venv-selector").setup({
    options = {
        log_level = "INFO",
        notify_user_on_venv_activation = true,
    },
})

require("which-key").add({ { "<localleader>p", group = "Python" } })
vim.keymap.set("n", "<localleader>pv", "<cmd>VenvSelect<cr>", { desc = "Virtual Env" })
