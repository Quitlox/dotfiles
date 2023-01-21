----------------------------------------
-- [Module] Encoding
----------------------------------------
-- Don't display if encoding is UTF-8.
local encoding = function()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end
----------------------------------------
-- [Module] Fileformat
----------------------------------------
-- Don't display if &ff is unix.
local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end
local filename = {
    "filename",
    path = 0,
    symbols = {
        modified = "",
        readonly = "",
        unnamed = "",
        newfile = "",
    },
}

----------------------------------------
-- [Module] Breadcrumbs (Navic)
----------------------------------------
-- Retain the breadcrumbs even while buffer is inactive

local breadcrumbs = function(highlight)
    -- Import Navic
    local status_ok, navic = pcall(require, "nvim-navic")
    if not status_ok then return "" end

    -- Wrapper around navic to remember last value
    vim.b.navic_last = ""
    local function get_location()
        if navic.is_available() then vim.b.navic_last = navic.get_location({ highlight = highlight }) end
        if vim.b.navic_last == nil then return "" end
        return vim.b.navic_last
    end

    return { get_location, separator = { left = "", right = "" } }
end

----------------------------------------
-- [Module] YAML Schema (yaml-companion)
----------------------------------------
function yaml_schema()
    -- Import yaml-companion
    local status_ok, yaml = pcall(require, "yaml-companion")
    if not status_ok then return "" end

    local schema = yaml.get_buf_schema(0)
    if schema then return schema.result[1].name end
    return ""
end

----------------------------------------
-- [Module] Terminal
----------------------------------------
local toggleterm = {
    '%{&ft == "toggleterm" ? "terminal (".b:toggle_number.")" : ""}',
    cond = function() return vim.bo.filetype == "toggleterm" end,
}

----------------------------------------
-- Statusline: Setup
----------------------------------------

import({ "lualine", "lualine.themes.vscode", "lspsaga", "nvim-navic" }, function(modules)
    local lualine = modules.lualine
    local vscode = modules["lualine.themes.vscode"]
    local navic = modules["nvim-navic"]

    local c = require("vscode.colors").get_colors()

    -- Custom Colors for Lualine
    vscode.normal.a.fg = "white"
    vscode.normal.b.fg = "white"
    vscode.normal.c.fg = "white"
    -- Custom highlighting for the winbar breadcrumbs
    vscode.inactive.b.bg = c.vscBack
    vscode.inactive.b.fg = c.vscCursorLight

    lualine.setup({
        options = {
            theme = vscode,
            icons_enabled = true,

            component_separators = "|",
            section_separators = { left = "", right = "" },

            disabled_filetypes = {
                statusline = { "NvimTree" },
                winbar = {
                    "NvimTree",
                    "dap-repl",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_watches",
                    "dapui_console",
                },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    separator = { left = "█" }, -- alt: 
                    padding = { right = 1 },
                    fmt = function(str) return str:sub(1, 1) end,
                },
            },
            lualine_b = {
                "diff",
                "diagnostics",
                "gutentags#statusline",
            },
            lualine_c = { filename, "nvim-treesitter#statusline" },
            lualine_x = { encoding, fileformat, yaml_schema, "filetype" },
            lualine_y = { { "b:gitsigns_head", color = { fg = "white" }, icon = { "", color = { fg = "white" } } } },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { filename },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },

        winbar = {
            lualine_a = {},
            lualine_b = { breadcrumbs(true), toggleterm },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = { breadcrumbs(false), toggleterm },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },

        extensions = {},
    })
end)
