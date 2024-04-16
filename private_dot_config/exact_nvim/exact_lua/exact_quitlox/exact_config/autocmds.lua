-- close some filetypes with <q>
vim.api.nvim_create_autocmd("filetype", {
    group = vim.api.nvim_create_augroup("close_with_q", {}),
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
        "oil",

        "neotest-output",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, nowait = true })
    end,
})
