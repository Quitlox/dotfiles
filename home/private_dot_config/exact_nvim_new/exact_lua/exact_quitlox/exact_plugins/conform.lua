-- +---------------------------------------------------------+
-- | stevearc/conform.nvim: Formatting                       |
-- +---------------------------------------------------------+

local excluded_filetypes = { toml = true, yaml = true, markdown = true, json = true, jsonc = true }

--+- Helper Functions: Fidget Integration -------------------+
local function display_fidget(title, msg)
    return require("fidget.progress").handle.create({
        title = title,
        message = msg,
        lsp_client = { name = "conform" }, -- the fake lsp client name
        percentage = nil, -- skip percentage field
    })
end

local function handle_error(err, fmt_info, msg_handle)
    if err then vim.notify(err, vim.log.levels.WARN, { title = fmt_info }) end
    msg_handle:finish()
end

local function get_available_formatter_names(format_args)
    local conform = require("conform")
    local formatters = conform.list_formatters()

    -- Return names of available formatters
    if not vim.tbl_isempty(formatters) then return vim.tbl_map(function(f) return f.name end, formatters) end
    -- If available, fallback to lsp formatting
    return conform.will_fallback_lsp(format_args) and { "lsp" } or nil
end

local function format(format_args)
    local fmt_names = get_available_formatter_names(format_args)
    if not fmt_names then return end

    local msg = "fmt: " .. table.concat(fmt_names, "/")
    local msg_handle = display_fidget(msg)

    require("conform").format(format_args, function(err) handle_error(err, msg, msg_handle) end)
end

--+- Helper Functions: Disable Autoformat on conditions -----+
local function should_format_on_save()
    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")

    -- Don't format on save for certain filenames
    if filename == "pyproject.toml" then return false end
    -- Don't format on save for certain filetypes
    if excluded_filetypes[vim.bo.filetype] then return false end
    -- Don't format on save in the chezmoi directory
    if filepath:match("chezmoi") then return false end

    return true
end

local function format_on_save(format_args)
    if not should_format_on_save() then return end
    if not require("quitlox.utils.format").enabled() then return end
    format(format_args)
end

--+- Setup --------------------------------------------------+
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "pycln", "black", "isort" },
        go = { "gofmt" },
        javascript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        typescript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        svelte = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        markdown = { { "prettierd", "prettier" }, "injected" },
        toml = { "taplo" },
        yaml = { { "prettier", "prettierd" } },
        json = { { "prettier", "prettierd" } },
        jsonc = { { "prettier", "prettierd" } },
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return format_on_save({ timeout_ms = 1000 })
    end,
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "gf", function() format({ async = true }) end, { desc = "Format Buffer" })