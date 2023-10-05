----------------------------------------
-- SETTINGS
----------------------------------------
local winbar_disabled_filetypes = {
    "dap-repl",
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui_console",
    "edgy",
    "neo-tree",
}

----------------------------------------
-- Import Plugins
----------------------------------------
-- Require Lualine
local lualine = require("lualine")

----------------------------------------
-- Import Modules
----------------------------------------

local encoding = require("quitlox.plugins.interface.components.base.statusline.modules.encoding")
local fileformat = require("quitlox.plugins.interface.components.base.statusline.modules.fileformat")
local filename = require("quitlox.plugins.interface.components.base.statusline.modules.filename")
local breadcrumbs = require("quitlox.plugins.interface.components.base.statusline.modules.breadcrumbs")
local yaml_schema = require("quitlox.plugins.interface.components.base.statusline.modules.yaml_schema")
local diff = require("quitlox.plugins.interface.components.base.statusline.modules.diff")
local mixed_indent = require("quitlox.plugins.interface.components.base.statusline.modules.mixed_indent")

----------------------------------------
-- Modules
----------------------------------------

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

local keymap = {
    function()
        if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then return "⌨ " .. vim.b.keymap_name end
        return ""
    end,
}

local lazy = {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = "ff9e64" },
}

----------------------------------------
-- Lualine Setup
----------------------------------------

lualine.setup({
    options = {
        theme = "catppuccin",
        disabled_filetypes = {
            winbar = {
                "neo-tree",
                "NvimTree",
                "dap-repl",
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "dapui_watches",
                "dapui_console",
            },
        },
        globalstatus = true,
    },
    sections = {
        lualine_a = { mode },
        lualine_b = { "branch" },
	-- lualine_c = { filename, require("lsp-progress").progress },
        lualine_c = { filename },
        lualine_x = { keymap, mixed_indent, encoding, fileformat, yaml_schema, "filetype" },
        lualine_y = { lazy, diff, diagnostics },
        lualine_z = { "searchcount", "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { "branch" },
        lualine_c = { filename },
        lualine_x = { "location" },
        lualine_y = { lazy },
        lualine_z = {},
    },

    winbar = {
        lualine_a = {},
        lualine_b = { breadcrumbs(true) },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { filename },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { breadcrumbs(false) },
        lualine_c = {},
        lualine_x = { filename },
        lualine_y = {},
        lualine_z = {},
    },

    extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
})
