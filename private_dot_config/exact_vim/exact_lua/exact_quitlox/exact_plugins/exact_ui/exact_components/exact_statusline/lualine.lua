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
local lualine = require("lualine")
-- Dependency: VSCode Theme
local colors = require("vscode.colors")
local vscode_theme = require("lualine.themes.vscode")

----------------------------------------
-- Import Modules
----------------------------------------

local encoding = require("quitlox.plugins.ui.components.statusline.modules.encoding")
local fileformat = require("quitlox.plugins.ui.components.statusline.modules.fileformat")
local filename = require("quitlox.plugins.ui.components.statusline.modules.filename")
local breadcrumbs = require("quitlox.plugins.ui.components.statusline.modules.breadcrumbs")
local yaml_schema = require("quitlox.plugins.ui.components.statusline.modules.yaml_schema")
local toggleterm = require("quitlox.plugins.ui.components.statusline.modules.terminal")

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
-- Modules
----------------------------------------

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
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

local mode = {
    "mode",
    separator = { left = "█" }, -- alt: 
    padding = { right = 1 },
    fmt = function(str) return str:sub(1, 1) end,
}

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
}

local gitsigns = {
    "b:gitsigns_status",
    -- color = { fg = "white" },
    -- icon = { "", color = { fg = "white" } },
    icon = { "" },
}

local lazy = {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = "ff9e64" },
}

-- TODO: Forces swenv to load, should only load on ft python
local swenv = {
    "swenv",
    cond = function() return vim.bo.filetype == "python" end,
}

----------------------------------------
-- Lualine Setup
----------------------------------------

lualine.setup({
    options = {
        theme = vscode_theme,

        -- component_separators = "|",
        section_separators = { left = "", right = "" },

        disabled_filetypes = {
            -- statusline = { "NvimTree" },
            winbar = winbar_disabled_filetypes,
        },
        always_divide_middle = true, -- default
        globalstatus = true,
    },
    sections = {
        lualine_a = { mode },
        lualine_b = { "branch", "swenv" },
        lualine_c = { filename, "man", "nvim-dap-ui", "man" },
        lualine_x = { encoding, fileformat, yaml_schema, "filetype" },
        lualine_y = { lazy, gitsigns, diagnostics },
        lualine_z = { "searchcount", "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { "branch", "swenv" },
        lualine_c = { filename },
        lualine_x = { "location" },
        lualine_y = { lazy },
        lualine_z = {},
    },

    winbar = {
        lualine_a = {},
        lualine_b = { breadcrumbs(true), "toggleterm" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { filename },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { breadcrumbs(false), "toggleterm" },
        lualine_c = {},
        lualine_x = { filename },
        lualine_y = {},
        lualine_z = {},
    },

    extensions = { "man", "nvim-dap-ui", "nvim-tree", "toggleterm" },
})
