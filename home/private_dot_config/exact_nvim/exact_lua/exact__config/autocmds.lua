-- rocks-git.nvim clones plugin repos, but plugins that .gitignore their
-- doc/tags file (most do) end up without helptags. rocks.nvim calls
-- `helptags ALL` in postInstall(), but git-sourced plugins aren't added
-- to the runtimepath at that point, so the call is a no-op for them.
-- Regenerate helptags once at startup to fill the gap.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("MyGenerateHelptags", { clear = true }),
    once = true,
    callback = function()
        pcall(vim.cmd.helptags, "ALL")
    end,
})

-- Automatically resize Windows when resizing the terminal or opening a terminal
vim.api.nvim_create_autocmd({ "VimResized", "TermOpen" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("MyAutoResizeWindows", { clear = true }),
    command = "wincmd =",
})

-- Set quickfix buffers as unlisted
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("MyHideQuickFix", { clear = true }),
    command = "set nobuflisted",
})

-- Close specific filetypes with <q>
vim.api.nvim_create_autocmd("filetype", {
    group = vim.api.nvim_create_augroup("MyCloseWithQ", { clear = true }),
    pattern = {
        "help",
        "man",
        "qf",

        "plenarytestpopup",
        "lspinfo",
        "checkhealth",
        "startuptime",

        "notify",
        "spectre_panel",
        "OverseerList",
        "CodeAction",

        "neotest-output",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, nowait = true })
    end,
})
