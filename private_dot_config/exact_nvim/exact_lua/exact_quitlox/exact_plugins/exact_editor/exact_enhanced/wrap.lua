local filetypes = {
    "asciidoc",
    "gitcommit",
    "mail",
    "markdown",
    "rst",
    "tex",
    "text",
}

-- Automatically set textwidth=80 for certain filetypes
vim.api.nvim_create_autocmd("filetype", {
    group = vim.api.nvim_create_augroup("HardWrapFileType", {}),
    pattern = filetypes,
    callback = function(event)
        vim.opt_local.textwidth = 80
    end,
})

return {
    {
        "andrewferrier/wrapping.nvim",
        ft = filetypes,
        cmd = { "HardWrapMode", "SoftWrapMode", "ToggleWrapMode", "WrappingOpenLog" },
        opts = {
            create_keymappings = false,
            auto_set_mode_filetype_allowlist = filetypes,
        },
    },
    -- stylua: ignore
    require("quitlox.util").whichkey({ ["<leader>Tw"] = { function() require("wrapping").toggle_wrap_mode() end, "Toggle wrap mode" } }),
    require("quitlox.util").legendary({
        { ":HardWrapMode", "wrapping.nvim: toggle hard wrap mode" },
        { ":SoftWrapMode", "wrapping.nvim: toggle soft wrap mode" },
        { ":ToggleWrapMode", "wrapping.nvim: toggle wrap mode" },
        { ":WrappingOpenLog", "wrapping.nvim: open log file" },
    }),
}
