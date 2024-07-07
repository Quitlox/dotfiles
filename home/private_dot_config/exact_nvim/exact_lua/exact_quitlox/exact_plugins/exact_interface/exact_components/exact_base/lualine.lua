----------------------------------------
-- SETTINGS
----------------------------------------

-- Update the statusline when the git signs are updated
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", {}),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
})

----------------------------------------
-- Define Modules
----------------------------------------

local mixed_indent_func = function()
    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]
    local space_indent = vim.fn.search(space_pat, "nwc")
    local tab_indent = vim.fn.search(tab_pat, "nwc")
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line
    if not mixed then
        mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
        mixed = mixed_same_line > 0
    end
    if not mixed then
        return ""
    end
    if mixed_same_line ~= nil and mixed_same_line > 0 then
        return "" .. mixed_same_line
    end
    local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
    local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
    if space_indent_cnt > tab_indent_cnt then
        return "" .. tab_indent
    else
        return "" .. space_indent
    end
end

local function py_venv_func()
    local actived_venv = function()
        local venv_name = require("venv-selector").get_active_venv()
        if venv_name ~= nil then
            if string.find(venv_name, "pypoetry") ~= nil then
                return string.gsub(venv_name, ".*/pypoetry/virtualenvs/", "poetry")
            end

            local find_venv = string.find(venv_name, "./venv")
            local find_dot_venv = string.find(venv_name, "/.venv")
            if find_venv ~= nil then
                return string.sub(venv_name, find_venv[0], -1)
            end
            if find_dot_venv ~= nil then
                return string.sub(venv_name, find_dot_venv + 1, -1)
            end

            return venv_name
        end

        return "none"
    end

    if vim.bo.filetype ~= "python" then
        return ""
    end
    return "(" .. actived_venv() .. ")"
end

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

local py_venv = {
    py_venv_func,
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
            lualine_y = { filetype, encoding, fileformat, py_venv, yaml },
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
