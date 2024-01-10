vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable format-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable format-on-save",
})
vim.api.nvim_create_user_command("FormatToggle", function()
    if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
    else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
    end
end, {
    desc = "Re-enable format-on-save",
    bang = true,
})

function init_msg_progress(title, msg)
    return require("fidget.progress").handle.create({
        title = title,
        message = msg,
        lsp_client = { name = "conform" }, -- the fake lsp client name
        percentage = nil, -- skip percentage field
    })
end

function format(format_args)
    local have_fmt, fmt_util = pcall(require, "conform")
    if have_fmt then
        -- get current formatter names
        local formatters = fmt_util.list_formatters()
        local fmt_names = {}

        if not vim.tbl_isempty(formatters) then
            fmt_names = vim.tbl_map(function(f) return f.name end, formatters)
        elseif fmt_util.will_fallback_lsp(format_args) then
            fmt_names = { "lsp" }
        else
            return
        end

        local fmt_info = "fmt: " .. table.concat(fmt_names, "/")
        local msg_handle = init_msg_progress(fmt_info)

        -- format with auto close popup, and notify if err
        fmt_util.format(format_args, function(err)
            msg_handle:finish()
            if err then vim.notify(err, vim.log.levels.WARN, { title = fmt_info }) end
        end)
    else
        vim.lsp.buf.format(format_args)
    end
end

function format_on_save(format_args)
    -- Custom: disable autoformat in pyproject.toml
    if vim.fn.expand("%:t") == "pyproject.toml" then return end
    -- Custom: disable autoformat for certain filetypes
    if vim.bo.filetype == "toml" then return end
    if vim.bo.filetype == "markdown" then return end
    if vim.bo.filetype == "json" then return end
    if vim.bo.filetype == "jsonc" then return end
    -- Custom: disable autoformat for chezmoi
    if vim.fn.expand("%:p"):match("chezmoi") then return end

    local fmt_util = require("conform")
    local formatters = fmt_util.list_formatters()
    local fmt_names = {}

    if not vim.tbl_isempty(formatters) then
        fmt_names = vim.tbl_map(function(f) return f.name end, formatters)
    elseif fmt_util.will_fallback_lsp(format_args) then
        fmt_names = { "lsp" }
    else
        return
    end

    local fmt_info = "fmt: " .. table.concat(fmt_names, "/")
    local msg_handle = init_msg_progress(fmt_info)

    return format_args, function(err)
        if err then vim.notify(err, vim.log.levels.WARN, { title = fmt_info }) end
        msg_handle:finish()
    end
end

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo", "FormatEnable", "FormatDisable", "FormatToggle" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "pycln", "black", "isort" },
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                svelte = { { "prettierd", "prettier" } },
                markdown = { { "prettierd", "prettier" }, "injected" },
                toml = { "taplo" },
                ["_"] = { "trim_whitespace" },
            },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return format_on_save({ timeout_ms = 500 })
            end,
        },
        keys = {
            { "<leader>Tf", "<cmd>FormatToggle<cr>", desc = "Toggle format-on-save" },
            { "gf", function() format({ async = true }) end, mode = "", desc = "Format buffer" },
        },
    },
    require("quitlox.util").legendary({
        { ":FormatDisable", "Disable format-on-save" },
        { ":FormatEnable", "Re-enable format-on-save" },
        { ":FormatToggle", "Toggle format-on-save" },
        { ":ConformInfo", "Show formatter (conform.nvim) info" },
    }),
}
