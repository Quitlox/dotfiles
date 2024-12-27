--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local trunc = function(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width and win_width < hide_width then
            return ""
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
        end
        return str
    end
end

--+- Integration: GitSigns ----------------------------------+
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", { clear = true }),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
})

--+- Define Modules -----------------------------------------+
local encoding = function()
    local replaced, _count = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return replaced
end

local python_venv = function()
    local cwd = vim.fn.getcwd()
    local venv = require("venv-selector").venv()
    if venv == nil then
        return ""
    end

    if venv:sub(1, #cwd) == cwd then
        return "(" .. venv:sub(#cwd + 2) .. ")"
    end

    return venv
end

local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

local active_linters = function()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return "󰦕 "
    end
    return "󱉶  " .. table.concat(linters, ", ")
end

local fancy_cwd = {
    function()
        -- Return only the last directory in the path
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    icon = " ",
    fmt = trunc(160, 30, nil, false),
}

local linters = {
    function()
        local ft_formatters = require("lint").linters_by_ft[vim.bo.filetype]
        return ft_formatters and table.concat(require("lint").linters_by_ft[vim.bo.filetype], " ") or "None"
    end,
    icon = "󱉶 ",
}

local formatters = {
    function()
        local ft_formatters = require("conform").formatters_by_ft[vim.bo.filetype]
        return ft_formatters and table.concat(require("conform").formatters_by_ft[vim.bo.filetype], " ") or "None"
    end,
    icon = "󱄽 ",
}

local git_blame = {
    "b:gitsigns_blame_line",
    fmt = trunc(180, 40, 140, true),
    icon = " ",
}

--+- Customize Modules --------------------------------------+
local branch = { "b:gitsigns_head", icon = " ", fmt = trunc(80 * 4, 20, nil, false) }
local midsection = { "%=", color = nil }
local filetype = { "filetype", colored = false }

--+- Options ------------------------------------------------+
vim.opt.laststatus = 3
-- vim.opt.cmdheight = 0

--+- Theme --------------------------------------------------+
local catppuccin_color_utils = require("catppuccin.utils.colors")
local catppuccin_pallete = require("catppuccin.palettes").get_palette()
local catppuccin_theme = require("lualine.themes.catppuccin")
catppuccin_theme.terminal.a.bg = catppuccin_pallete.teal
catppuccin_theme.terminal.b.fg = catppuccin_pallete.teal

--+- Setup --------------------------------------------------+
require("lualine").setup({
    options = {
        theme = catppuccin_theme,
        -- component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            winbar = {
                "neo-tree",
                "gitlab",
                "dap-repl",
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "dapui_watches",
                "dapui_console",
                "jinja", -- buggy
            },
            statusline = {
                "jinja", -- buggy
            },
        },
        globalstatus = true,
    },
    sections = {
        lualine_a = { fancy_cwd },
        lualine_b = { branch },
        lualine_c = { "my_pretty_path", "my_fancy_macro", git_blame, midsection },
        lualine_x = { "my_fancy_diff", "my_fancy_diagnostics", "overseer", active_linters },
        lualine_y = { "mixed_indent", encoding, fileformat, "my_fancy_lsp_servers", python_venv },
        lualine_z = { "my_fancy_searchcount", "my_fancy_location" },
    },
    inactive_sections = {
        lualine_a = { fancy_cwd },
        lualine_b = { branch },
        lualine_c = { "my_pretty_path" },
        lualine_x = { "mixed_indent" },
        lualine_y = { encoding, fileformat },
        lualine_z = { "my_fancy_searchcount", "my_fancy_location" },
    },

    extensions = { "fzf", "man", "neo-tree", "nvim-dap-ui", "oi", "overseer", "quickfix", "trouble" },
})
