----------------------------------------
-- SETTINGS
----------------------------------------
local winbar_disabled_filetypes = {
    "NvimTree",
    "dap-repl",
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui_console",
}

----------------------------------------
-- Import Plugins
----------------------------------------
-- Require Lualine
local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then return end
-- Depencency: Nvim-Navic
local navic_ok, navic = pcall(require, "nvim-navic")
if not navic_ok then return end
-- Dependency: VSCode Theme
local colors_ok, colors = pcall(require, "vscode.colors")
if not colors_ok then return end

-- Safe Requires
local vscode_theme = require("lualine.themes.vscode")

----------------------------------------
-- Import Modules
----------------------------------------
local encoding = require("quitlox.plugins.statusline.modules.encoding")
local fileformat = require("quitlox.plugins.statusline.modules.fileformat")
local filename = require("quitlox.plugins.statusline.modules.filename")
local breadcrumbs = require("quitlox.plugins.statusline.modules.breadcrumbs")
local yaml_schema = require("quitlox.plugins.statusline.modules.yaml_schema")
local toggleterm = require("quitlox.plugins.statusline.modules.terminal")

----------------------------------------
-- Adapted Theme VSCode
----------------------------------------

-- Custom Colors for Lualine
vscode_theme.normal.a.fg = "white"
vscode_theme.normal.b.fg = "white"
vscode_theme.normal.c.fg = "white"
-- Custom highlighting for the winbar breadcrumbs
vscode_theme.inactive.b.bg = colors.vscBack
vscode_theme.inactive.b.fg = colors.vscCursorLight

----------------------------------------
-- Lualine Sections
----------------------------------------

local mode = {
    "mode",
    separator = { left = "█" }, -- alt: 
    padding = { right = 1 },
    fmt = function(str) return str:sub(1, 1) end,
}
local gitsigns = {
    "b:gitsigns_head",
    color = { fg = "white" },
    icon = { "", color = { fg = "white" } },
}

----------------------------------------
-- Lualine Setup
----------------------------------------

lualine.setup({
    options = {
        theme = vscode_theme,

        component_separators = "|",
        section_separators = { left = "", right = "" },

        disabled_filetypes = {
            statusline = { "NvimTree" },
            winbar = winbar_disabled_filetypes,
        },
        always_divide_middle = true, -- default
        globalstatus = true,
    },
    sections = {
        lualine_a = { mode },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { filename, "nvim-treesitter#statusline" },
        lualine_x = { encoding, fileformat, yaml_schema, "filetype" },
        lualine_y = { gitsigns },
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
