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

-- Update the statusline when the git signs are updated
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", {}),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
})

----------------------------------------
-- Import Modules
----------------------------------------

local mixed_indent_func = require("quitlox.plugins.interface.components.base.statusline.modules.mixed_indent")
local py_virtual_env = require("quitlox.plugins.interface.components.base.statusline.modules.py_virtual_env")

local encoding = function()
    local replaced, _count = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return replaced
end

local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

local linters = function()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return "󰦕 "
    end
    return "󱉶  " .. table.concat(linters, ", ")
end

local yaml_schema = function()
    -- Only show the schema if the current buffer is a yaml file
    if vim.bo.filetype ~= "yaml" then
        return ""
    end

    -- Import yaml-companion
    -- local yaml = require("yaml-companion")

    -- local schema = yaml.get_buf_schema(0)
    -- if schema then return schema.result[1].name end
    return ""
end

----------------------------------------
-- Inline Modules
----------------------------------------

-----------------
--  Section A
-----------------
local mode = {
    "mode",
    fmt = function(str)
        return str:sub(1, 1)
    end,
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
    cond = function()
        return vim.bo.filetype ~= "NvimTree"
    end,
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

local overseer = {
    "overseer",
    label = "", -- Prefix for task counts
    colored = true, -- Color the task icons and counts
    unique = false, -- Unique-ify non-running task count by name
    name = nil, -- List of task names to search for
    name_not = false, -- When true, invert the name search
    status = nil, -- List of task statuses to display
    status_not = false, -- When true, invert the status search
}

-------------------
--  Component X
-------------------
local keymap = {
    function()
        if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
            return "⌨ " .. vim.b.keymap_name
        end
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
    init = function()
        vim.opt.laststatus = 3
    end,
    opts = {
        options = {
            theme = "catppuccin",
            component_separators = " ",
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
            lualine_x = { keymap, mixed_indent, overseer, lazy, "fancy_diff", "fancy_diagnostics" },
            lualine_y = { filetype, encoding, fileformat, python, yaml },
            lualine_z = { "fancy_searchcount", "location" },
        },
        inactive_sections = {
            lualine_a = { mode },
            lualine_b = { branch },
            lualine_c = { filename },
            lualine_x = { keymap, mixed_indent },
            lualine_y = { filetype, encoding, fileformat },
            lualine_z = { "fancy_searchcount", "location" },
        },

        extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
    },
}
