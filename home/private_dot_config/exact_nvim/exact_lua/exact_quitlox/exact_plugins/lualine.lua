-- +---------------------------------------------------------+
-- | lualine.nvim: Statusline and Winbar                     |
-- +---------------------------------------------------------+

local trunc = require("quitlox.util.lualine").trunc

--+- Integration: GitSigns ----------------------------------+
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", { clear = true }),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
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

local vector_code = {
    function()
        return require("vectorcode.integrations").lualine({})[1]()
    end,
    cond = function()
        if package.loaded["vectorcode"] == nil then
            return false
        else
            return require("vectorcode.integrations").lualine({}).cond()
        end
    end,
}

local mcp_hub = {
    require("mcphub.extensions.lualine"),
    cond = function()
        return package.loaded["mcphub"] ~= nil
    end,
}

--+- Customize Modules --------------------------------------+
local branch = { "b:gitsigns_head", icon = " ", fmt = trunc(80 * 4, 20, nil, false) }
local git_blame = { "b:gitsigns_blame_line", icon = " ", fmt = trunc(180, 40, 140, true) }
local navic = { "navic", color_correction = "static" }

--+- Options ------------------------------------------------+
vim.opt.laststatus = 3

--+- Theme --------------------------------------------------+
local catppuccin_pallete = require("catppuccin.palettes").get_palette()
local catppuccin_theme = require("lualine.themes.catppuccin")
catppuccin_theme.terminal.a.bg = catppuccin_pallete.teal
catppuccin_theme.terminal.b.fg = catppuccin_pallete.teal

--+- Setup --------------------------------------------------+
require("lualine").setup({
    options = {
        theme = catppuccin_theme,
        component_separators = " ",
        section_separators = { left = "", right = "" },

        globalstatus = true,
        always_show_tabline = false,

        disabled_filetypes = {
            winbar = {
                "neo-tree",
                "gitlab",
                "dap-repl",
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "dapui_watches",
                "dapui_console",
                "Avante",
                "AvanteInput",
                "jinja", -- buggy
            },
            statusline = {
                "jinja", -- buggy
            },
        },
    },
    sections = {
        lualine_a = { "my_cwd" },
        lualine_b = { branch },
        lualine_c = { "my_pretty_path", "my_fancy_macro", git_blame, "%=" },
        lualine_x = { "overseer" },
        lualine_y = { "my_active_linters", "my_fancy_lsp_servers", "my_python_venv" },
        lualine_z = { "my_mixed_indent", encoding, fileformat, "my_fancy_searchcount", "my_fancy_location" },
    },
    inactive_sections = {
        lualine_a = { "my_cwd" },
    },

    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "my_pretty_path", "navic" },
        lualine_x = { "my_fancy_diff" },
        lualine_y = { "my_fancy_diagnostics" },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "my_pretty_path", "navic" },
        lualine_x = { "my_fancy_diff" },
        lualine_y = { "my_fancy_diagnostics" },
        lualine_z = {},
    },

    tabline = {
        lualine_a = {
            {
                "tabs",
                mode = 2,
                show_modified_status = false,
                max_length = function()
                    return vim.o.columns
                end,
            },
        },
    },

    extensions = {
        "aerial",
        "fzf",
        "man",
        "neo-tree",
        "nvim-dap-ui",
        "oil",
        "overseer",
        "quickfix",
        "trouble",

        -- Custom
        {
            filetypes = { "codecompanion" },
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "my_pretty_path" },
                lualine_x = { mcp_hub, vector_code },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },
})

--+- Behaviour: Auto Rename Tabs ----------------------------+
vim.api.nvim_create_autocmd({ "TabNew", "TabEnter", "TabLeave", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("MyLualineTabRename", { clear = true }),
    callback = function()
        local tcd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        pcall(vim.cmd, [[LualineRenameTab ]] .. tcd .. [[]])
    end,
})
