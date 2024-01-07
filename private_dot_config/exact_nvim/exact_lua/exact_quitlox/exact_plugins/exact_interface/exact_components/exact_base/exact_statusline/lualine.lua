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
-- Import Modules
----------------------------------------

local diff = require("quitlox.plugins.interface.components.base.statusline.modules.diff")
local encoding = require("quitlox.plugins.interface.components.base.statusline.modules.encoding")
local fileformat = require("quitlox.plugins.interface.components.base.statusline.modules.fileformat")
local filename = require("quitlox.plugins.interface.components.base.statusline.modules.filename")
local linters = require("quitlox.plugins.interface.components.base.statusline.modules.linters")
local mixed_indent = require("quitlox.plugins.interface.components.base.statusline.modules.mixed_indent")
local py_virtual_env = require("quitlox.plugins.interface.components.base.statusline.modules.py_virtual_env")
local yaml_schema = require("quitlox.plugins.interface.components.base.statusline.modules.yaml_schema")

----------------------------------------
-- Inline Modules
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

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    opts = {
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
            lualine_c = { filename },
            lualine_x = { keymap, mixed_indent, encoding, fileformat, yaml_schema, linters, py_virtual_env, "filetype" },
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

        extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
    },
}
