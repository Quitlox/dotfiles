require("kulala").setup()

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyHttpOptions", { clear = true }),
    pattern = { "http" },
    callback = function(event) vim.opt_local.formatoptions:remove({ "r" }) end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyHttpKeybinding", { clear = true }),
    pattern = { "http" },
    callback = function(event)
        vim.keymap.set("n", "<localleader>hr", function() require("kulala").run() end, { buffer = event.buf, silent = true, nowait = true })
        vim.keymap.set("n", "K", function() require("kulala").run() end, { buffer = event.buf, silent = true, nowait = true })
        vim.keymap.set("n", "<localleader>hc", function() require("kulala").copy() end, { buffer = event.buf, silent = true, nowait = true })
        vim.keymap.set("n", "<localleader>ht", function() require("kulala").toggle_view() end, { buffer = event.buf, silent = true, nowait = true })
        vim.keymap.set("n", "]h", function() require("kulala").jump_next() end, { buffer = event.buf, silent = true, nowait = true })
        vim.keymap.set("n", "[h", function() require("kulala").jump_prev() end, { buffer = event.buf, silent = true, nowait = true })
        require("which-key").add({ { "<localleader>h", group = "HTTP" } })
    end,
})
