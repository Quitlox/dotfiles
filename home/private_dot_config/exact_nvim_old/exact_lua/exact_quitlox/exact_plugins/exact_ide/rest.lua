return {
    "mistweaverco/kulala.nvim",
    config = function()
        -- Setup is required, even if you don't pass any options
        require("kulala").setup()
    end,
    ft = "http",
    init = function()
        vim.filetype.add({
            extension = {
                ["http"] = "http",
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("MyHttpOptions", { clear = true }),
            pattern = { "http" },
            callback = function(event) vim.opt_local.formatoptions:remove({ "r" }) end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("MyHttpKeybinding", { clear = true }),
            pattern = { "http" },
            callback = function(event)
                vim.keymap.set("n", "<localleader>hr", "<cmd>lua require('kulala').run()<cr>", { buffer = event.buf, silent = true, nowait = true })
                vim.keymap.set("n", "K", "<cmd>lua require('kulala').run()<cr>", { buffer = event.buf, silent = true, nowait = true })
                vim.keymap.set("n", "<localleader>hc", "<cmd>lua require('kulala').copy()<cr>", { buffer = event.buf, silent = true, nowait = true })
                vim.keymap.set("n", "<localleader>ht", "<cmd>lua require('kulala').toggle_view()<cr>", { buffer = event.buf, silent = true, nowait = true })
                vim.keymap.set("n", "]h", "<cmd>lua require('kulala').jump_next()<cr>", { buffer = event.buf, silent = true, nowait = true })
                vim.keymap.set("n", "[h", "<cmd>lua require('kulala').jump_prev()<cr>", { buffer = event.buf, silent = true, nowait = true })
            end,
        })
    end,
}
