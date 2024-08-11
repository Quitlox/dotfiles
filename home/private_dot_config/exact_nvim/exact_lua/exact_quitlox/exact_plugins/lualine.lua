local trunc = require("quitlox.util.misc").trunc

--+- Integration: GitSigns ----------------------------------+
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", {}),
    callback = function() require("lualine").refresh({ place = { "statusline" } }) end,
})

--+- Define Modules -----------------------------------------+
local encoding = function()
    local replaced, _count = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return replaced
end

local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

local active_linters = function()
    local linters = require("lint").get_running()
    if #linters == 0 then return "󰦕 " end
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
local midsection = { "%=", separator = { left = "" }, color = nil }
local filetype = { "filetype", colored = false }

--+- Options ------------------------------------------------+
vim.opt.laststatus = 3
-- vim.opt.cmdheight = 0

--+- Setup --------------------------------------------------+
require("lualine").setup({
    options = {
        theme = "catppuccin",
        component_separators = " ",
        -- component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
        lualine_x = { "my_fancy_diff", "my_fancy_diagnostics", "overseer", "mixed_indent", active_linters, "my_fancy_lsp_servers", "python_env" },
        lualine_y = { encoding, fileformat },
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

    extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
})
