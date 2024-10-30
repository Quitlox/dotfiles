---@diagnostic disable: assign-type-mismatch

-- +---------------------------------------------------------+
-- | stevearc/conform.nvim: Formatting                       |
-- +---------------------------------------------------------+

local default_opts = { timeout_ms = 500, lsp_format = "fallback" }
local excluded_filetypes = { toml = true, yaml = true, markdown = true, json = true, jsonc = true, tex = true }

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

local function get_available_formatter_names()
    local conform = require("conform")
    local formatters = conform.list_formatters_to_run()

    -- Return names of available formatters
    if not vim.tbl_isempty(formatters) then return vim.tbl_map(function(f) return f.name end, formatters) end
    return nil
end

local function format()
    local fmt_names = get_available_formatter_names()
    if not fmt_names then return end

    local msg = "fmt: " .. table.concat(fmt_names, "/")
    local msg_handle = display_fidget(msg)

    require("conform").format(default_opts, function(err) handle_error(err, msg, msg_handle) end)
end

--+- Helper Functions: Disable Autoformat on conditions -----+
local function should_format_on_save()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Don't autosave if disabled
    if not require("quitlox.util.format").enabled(bufnr) then return end

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

--+- Helper Functions: Slow Formatters Async ----------------+
local slow_format_filetypes = {}
local format_on_save_if_not_slow = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    local function on_format(err)
        if err and err:match("timeout$") then slow_format_filetypes[vim.bo[bufnr].filetype] = true end
    end

    return default_opts, on_format
end

local format_after_save_if_slow = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    return { lsp_format = "fallback" }
end

--+- Helper Functions: Format Range -------------------------+
vim.api.nvim_create_user_command("Format", function(args)
    -- Range format
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end

    -- Leave visual mode after range format
    require("conform").format({ lsp_format = "fallback", range = range }, function(err)
        if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true) end
        end
    end)
end, { range = true })

--+- Setup --------------------------------------------------+
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "pycln", "black", "isort" },
        go = { "gofmt" },
        javascript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        typescript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        sh = { "shfmt" },
        svelte = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        markdown = { { "prettierd", "prettier" }, "injected" },
        toml = { "taplo" },
        yaml = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(_bufnr)
        if not should_format_on_save() then return end
        return format_on_save_if_not_slow(_bufnr)
    end,
    format_after_save = function(_bufnr)
        if not should_format_on_save() then return end
        return format_after_save_if_slow(_bufnr)
    end,
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "gf", function() format() end, { desc = "Format Buffer" })
vim.keymap.set("v", "gf", "<cmd>Format<cr>", { desc = "Format Range" })
