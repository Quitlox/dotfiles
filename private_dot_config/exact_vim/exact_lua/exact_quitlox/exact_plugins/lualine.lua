----------------------------------------
-- Statusline: Custom Modules
----------------------------------------

-- Override 'encoding': Don't display if encoding is UTF-8.
local encoding = function()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end
-- fileformat: Don't display if &ff is unix.
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

local breadcrumbs = function()
	local status_ok, navic = pcall(require, "nvim-navic")
	if not status_ok then
		return ""
	end
    return { navic.get_location, cond = navic.is_available, separator = { left = "", right = "" } }
end
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

    -- Custom Colors for Lualine
    vscode.normal.a.fg = "white"
    vscode.normal.b.fg = "white"
    vscode.normal.c.fg = "white"

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
            lualine_x = { encoding, fileformat, "filetype" },
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
            lualine_b = { breadcrumbs(), toggleterm, },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {  toggleterm, },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },

        extensions = {},
    })
end)
