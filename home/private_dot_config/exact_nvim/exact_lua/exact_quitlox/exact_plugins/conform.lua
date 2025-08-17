---@diagnostic disable: assign-type-mismatch

-- +---------------------------------------------------------+
-- | stevearc/conform.nvim: Formatting                       |
-- +---------------------------------------------------------+

local default_opts = { timeout_ms = 500, lsp_format = "fallback" }
local excluded_filetypes = { "toml", "yaml", "markdown", "json", "jsonc", "tex", "yaml.ansible" }
local excluded_filenames = { "pyproject.toml", "__init__.py" }

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
    if err then
        vim.notify(err, vim.log.levels.WARN, { title = fmt_info })
    end
    msg_handle:finish()
end

local function get_available_formatter_names()
    local conform = require("conform")
    local formatters = conform.list_formatters_to_run()

    -- Return names of available formatters
    if not vim.tbl_isempty(formatters) then
        return vim.tbl_map(function(f)
            return f.name
        end, formatters)
    end
    return nil
end

local function format()
    local fmt_names = get_available_formatter_names()
    if not fmt_names then
        return
    end

    local msg = "fmt: " .. table.concat(fmt_names, "/")
    local msg_handle = display_fidget(msg)

    require("conform").format(default_opts, function(err)
        handle_error(err, msg, msg_handle)
    end)
end

--+- Helper Functions: Disable Autoformat on conditions -----+
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/format.lua#L99
local function enabled(buf)
    local gaf = vim.g.autoformat
    local baf = vim.b[buf].autoformat

    -- If the buffer has a local value, use that
    if baf ~= nil then
        return baf
    end

    -- Otherwise use the global value if set, or true by default
    return gaf == nil or gaf
end

local function should_format_on_save()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Don't autosave if disabled
    if not enabled(bufnr) then
        return
    end

    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")

    -- Don't format on save for certain filenames
    if vim.tbl_contains(excluded_filenames, filename) then
        return false
    end
    -- Don't format on save for certain filetypes
    if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
        return false
    end
    -- Don't format on save in the chezmoi directory
    if filepath:match("chezmoi") then
        return false
    end

    return true
end

--+- Helper Functions: Slow Formatters Async ----------------+
local slow_format_filetypes = { "python" }
local format_on_save_if_not_slow = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
    end
    local function on_format(err)
        if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
        end
    end

    return default_opts, on_format
end

local format_after_save_if_slow = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
    end
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
            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end)
end, { range = true })

--+- Setup --------------------------------------------------+
require("conform").setup({
    formatters_by_ft = {
        bib = { "bibtex-tidy" },
        go = { "gofmt" },
        javascript = { "prettierd", "eslint_d" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd", "injected" },
        nix = { "alejandra", "nixfmt" },
        python = { "pycln", "black", "isort" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        svelte = { "prettierd", "eslint_d" },
        toml = { "taplo" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
        yaml = { "prettierd" },
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(_bufnr)
        if not should_format_on_save() then
            return
        end
        return format_on_save_if_not_slow(_bufnr)
    end,
    format_after_save = function(_bufnr)
        if not should_format_on_save() then
            return
        end
        return format_after_save_if_slow(_bufnr)
    end,
    formatters = {
        pycln = {
            command = "pycln",
            args = {
                "--silence",
                "-a",
                "-",
            },
            cwd = require("conform.util").root_file({
                "pyproject.toml",
                "setup.cfg",
            }),
        },
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "gf", format, { desc = "Format Buffer" })
vim.keymap.set("v", "gf", "<cmd>Format<cr>", { desc = "Format Range" })

--+- Integration: snacks.nvim (Toggle) ----------------------+
---@param buf_local? boolean Whether to toggle autoformat for the current buffer only, or globally
local function toggle_format(buf_local)
    return Snacks.toggle.new({
        name = "Auto Format (" .. (buf_local and "Buffer" or "Global") .. ")",
        get = function()
            return enabled(vim.api.nvim_get_current_buf())
        end,
        set = function(state)
            local bufnr = vim.api.nvim_get_current_buf()
            if buf_local then
                vim.b[bufnr].autoformat = state
            else
                vim.g.autoformat = state
            end
        end,
    })
end

toggle_format(true):map("<leader>Tf")
toggle_format(false):map("<leader>TF")

--+- Support: Check Installation Status ------------------------+
local formatter_blacklist = { "trim_whitespace", "injected" }
local checked_formatter_filetypes = {}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ConformCheckInstallation", { clear = true }),
    callback = function(event)
        local conform = require("conform")
        local ft = vim.bo[event.buf].filetype

        -- Skip if we've already checked this filetype
        if checked_formatter_filetypes[ft] then
            return
        end

        -- Mark this filetype as checked
        checked_formatter_filetypes[ft] = true

        -- Get formatters for this filetype
        local formatters = conform.formatters_by_ft[ft]
        if not formatters then
            return
        end

        local missing_formatters = {}
        for _, formatter_name in ipairs(formatters) do
            if not vim.tbl_contains(formatter_blacklist, formatter_name) then
                -- Use get_formatter_info instead of directly accessing conform.formatters
                local formatter_info = require("conform").get_formatter_info(formatter_name)

                -- If formatter exists and has a command
                if formatter_info and formatter_info.command then
                    if vim.fn.executable(formatter_info.command) == 0 then
                        table.insert(missing_formatters, { name = formatter_name, cmd = formatter_info.command })
                    end
                end
            end
        end

        -- Notify user about missing formatters
        if #missing_formatters > 0 then
            local message = "Missing formatters for " .. ft .. ":\n"
            for _, formatter in ipairs(missing_formatters) do
                message = message .. "  - " .. formatter.name .. ": " .. formatter.cmd .. "\n"
            end
            vim.notify(message, vim.log.levels.WARN)
        end
    end,
})
