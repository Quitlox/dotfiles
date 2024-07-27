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

local linters = function()
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

--+- Customize Modules --------------------------------------+
local branch = { "b:gitsigns_head", icon = " ", fmt = trunc(80 * 4, 20, nil, false) }
local midsection = { "%=", separator = { left = "" }, color = nil }
local filetype = { "filetype", colored = false }
local py_venv = { "python_env", separator = { left = "" } }

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
            },
        },
        globalstatus = true,
    },
    sections = {
        lualine_a = { fancy_cwd },
        lualine_b = { branch },
        lualine_c = { "my_pretty_path", midsection },
        lualine_x = { linters, "mixed_indent", "overseer", "fancy_diff", "fancy_diagnostics" },
        lualine_y = { filetype, encoding, fileformat, py_venv },
        lualine_z = { "fancy_searchcount", "location" },
    },
    inactive_sections = {
        lualine_a = { fancy_cwd },
        lualine_b = { branch },
        lualine_c = { "my_pretty_path" },
        lualine_x = { "mixed_indent" },
        lualine_y = { filetype, encoding, fileformat },
        lualine_z = { "fancy_searchcount", "location" },
    },

    extensions = { "man", "nvim-dap-ui", "neo-tree", "toggleterm", "trouble", "overseer" },
})
