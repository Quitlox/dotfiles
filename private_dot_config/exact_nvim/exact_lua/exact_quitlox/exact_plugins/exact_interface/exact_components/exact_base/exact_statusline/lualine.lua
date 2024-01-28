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

local gitsigns_diff_source = require("quitlox.plugins.interface.components.base.statusline.modules.diff")
local encoding = require("quitlox.plugins.interface.components.base.statusline.modules.encoding")
local fileformat = require("quitlox.plugins.interface.components.base.statusline.modules.fileformat")
local linters = require("quitlox.plugins.interface.components.base.statusline.modules.linters")
local mixed_indent_func = require("quitlox.plugins.interface.components.base.statusline.modules.mixed_indent")
local py_virtual_env = require("quitlox.plugins.interface.components.base.statusline.modules.py_virtual_env")
local yaml_schema = require("quitlox.plugins.interface.components.base.statusline.modules.yaml_schema")

----------------------------------------
-- Inline Modules
----------------------------------------

-----------------
--  Section A
-----------------
local mode = {
    "mode",
    fmt = function(str) return str:sub(1, 1) end,
}

-----------------
--  Section B
-----------------
local branch = {
    "branch",
}

-----------------
--  Section C
-----------------
local filename = {
    "filename",
    path = 0,
    cond = function() return vim.bo.filetype ~= "NvimTree" end,
    symbols = {
        modified = "",
        readonly = "",
        unnamed = "",
        newfile = "",
    },
    separator = { right = "" },
}

local midsection = { "%=", separator = { left = "" }, color = nil }

local linting = {
    linters,
}

-------------------
--  Component X
-------------------
local keymap = {
    function()
        if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then return "⌨ " .. vim.b.keymap_name end
        return ""
    end,
}

local mixed_indent = {
    mixed_indent_func,
    icon = {
        "",
        name = "MixedIndent",
    },
    color = "DiagnosticError",
}

local lazy = {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = "ff9e64" },
}

local diff = {
    "diff",
    source = gitsigns_diff_source,
}

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
}
-- Component Y
local filetype = {
    "filetype",
    colored = false,
}

local python = {
    py_virtual_env,
    separator = { left = "" },
}

-- FIXME: Broken for some reason
local yaml = {
    yaml_schema,
    separator = { left = "" },
}

----------------------------------------
-- Lualine Setup
----------------------------------------

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- config = function() require("quitlox.plugins.interface.components.base.statusline.lualine") end,
    init = function() vim.opt.laststatus = 3 end,
    opts = {
        options = {
            theme = "catppuccin",
            component_separators = "⋅",
            disabled_filetypes = {
                winbar = {
                    "neo-tree",
                    "NvimTree",
                    "gitlab",
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
            lualine_b = { branch },
            lualine_c = { filename, midsection, linting },
            lualine_x = { keymap, mixed_indent, lazy, diff, diagnostics },
            lualine_y = { filetype, encoding, fileformat, python, yaml },
            lualine_z = { "searchcount", "location" },
        },
        inactive_sections = {
            lualine_a = { mode },
            lualine_b = { branch },
            lualine_c = { filename },
            lualine_x = { keymap, mixed_indent },
            lualine_y = { filetype, encoding, fileformat },
            lualine_z = { "searchcount", "location" },
        },

        extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
    },
}
