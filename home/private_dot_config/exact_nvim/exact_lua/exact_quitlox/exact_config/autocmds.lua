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

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("MyFloatingWindowMappings", { clear = true }),
    callback = function(args)
        local buf = args.buf

        -- Find the window with the buffer
        local win = -1
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(w) == buf then
                win = w
                break
            end
        end

        -- Set the keymaps for the floating window
        local filetype_blacklist = { "snacks_terminal", "snacks_win_backdrop" }
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" and not filetype_blacklist[vim.bo[buf].filetype] then
            -- Debug for when the keymap should not be set for a particular window
            local debug = false
            if debug then
                vim.notify("filetype: " .. vim.bo[buf].filetype, "info")
            end

            -- The window is floating
            -- vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })
            -- vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })
        end
    end,
})
