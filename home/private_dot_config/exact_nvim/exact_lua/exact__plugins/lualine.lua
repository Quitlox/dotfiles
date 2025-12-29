-- +---------------------------------------------------------+
-- | lualine.nvim: Statusline and Winbar                     |
-- +---------------------------------------------------------+

local trunc = require("_config.util.lualine").trunc

--+- Integration: GitSigns ----------------------------------+
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("LualineRefreshEvents", { clear = true }),
    callback = function()
        require("lualine").refresh({ place = { "statusline" } })
    end,
})

--+- Define Modules -----------------------------------------+
local autoformat_status = {
    function()
        local bufnr = vim.api.nvim_get_current_buf()
        local gaf = vim.g.autoformat
        local baf = vim.b[bufnr].autoformat

        -- Check if autoformat is enabled (same logic as conform.lua)
        local enabled
        if baf ~= nil then
            enabled = baf
            -- Buffer-local setting exists
            if not enabled then
                return "󱓁 B" -- Buffer-local disabled (use <leader>Tf)
            end
        else
            enabled = gaf == nil or gaf
            -- No buffer-local setting, using global
            if not enabled then
                return "󱓁 G" -- Global disabled (use <leader>TF)
            end
        end

        -- Enabled - show nothing
        return ""
    end,
    color = { fg = "#ff5555" }, -- Red color when disabled
}

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
    function()
        -- Check if MCPHub is loaded
        if not vim.g.loaded_mcphub then
            return "󰐻 -"
        end

        local count = vim.g.mcphub_servers_count or 0
        local status = vim.g.mcphub_status or "stopped"

        local executing = vim.g.mcphub_executing

        -- Show "-" when stopped
        if status == "stopped" then
            return "󰐻 -"
        end

        -- Show spinner when executing, starting, or restarting
        if executing or status == "starting" or status == "restarting" then
            local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local frame = math.floor(vim.loop.now() / 100) % #frames + 1
            return "󰐻 " .. frames[frame]
        end

        return "󰐻 " .. count
    end,
    color = function()
        if not vim.g.loaded_mcphub then
            return { fg = "#6c7086" } -- Gray for not loaded
        end

        local status = vim.g.mcphub_status or "stopped"

        if status == "ready" or status == "restarted" then
            return { fg = "#50fa7b" } -- Green for connected
        elseif status == "starting" or status == "restarting" then
            return { fg = "#ffb86c" } -- Orange for connecting
        else
            return { fg = "#ff5555" } -- Red for error/stopped
        end
    end,
    cond = function()
        return vim.bo.filetype == "codecompanion"
    end,
}

local function dart()
    local line = Dart.gen_tabline()
    -- removes the fill + “Tab x/y” part
    return line:gsub("%%#DartFill#.-$", "")
end

local function cc_spinner()
    local success, component = pcall(require, "codecompanion._extensions.spinner.styles.lualine")
    if not success then
        return nil
    end
    return component.get_lualine_component()
end

--+- Customize Modules --------------------------------------+
local branch = { "b:gitsigns_head", icon = " ", fmt = trunc(80 * 4, 20, nil, false) }
local git_blame = { "b:gitsigns_blame_line", icon = " ", fmt = trunc(180, 40, 140, true) }
local navic = { "navic", color_correction = "static" }
local python_venv = {
    "python",
    fmt = function(str)
        -- Handle various "no venv" states with a user-friendly message
        if str == "vim.NIL" or str == "no venv" or str == "" or str == nil or tostring(str) == "vim.NIL" then
            str = " (system)"
        end
        return trunc(4 * 80, 10, nil, false)(str)
    end,
    cond = function()
        local ft = vim.bo.filetype
        local filename = vim.fn.expand("%:t")
        return ft == "python" or filename == "pyproject.toml"
    end,
}

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
        always_show_tabline = true,

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
                "aerial",
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
        lualine_x = { cc_spinner(), "overseer", "my_loc_counter" },
        lualine_y = { autoformat_status, "my_active_linters", "my_fancy_lsp_servers", python_venv },
        lualine_z = { "my_mixed_indent", encoding, fileformat, "my_fancy_searchcount", "my_fancy_location" },
    },
    inactive_sections = {
        lualine_a = { "my_cwd" },
    },

    winbar = {
        lualine_a = {},
        lualine_b = { "my_pretty_path" },
        lualine_c = { "navic" },
        lualine_x = { "my_fancy_diff", vector_code, mcp_hub },
        lualine_y = { "my_fancy_diagnostics" },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { "my_pretty_path" },
        lualine_c = {
            {
                "navic",
                color_correction = "static",
                -- Disable navic's custom highlights for inactive winbar so it uses lualine's inactive colors
                navic_opts = { highlight = false },
            },
        },
        lualine_x = { "my_fancy_diff", vector_code, mcp_hub },
        lualine_y = { "my_fancy_diagnostics" },
        lualine_z = {},
    },

    tabline = {
        lualine_c = { dart },
        lualine_x = {
            {
                "tabs",
                mode = 2,
                show_modified_status = false,
            },
        },
    },

    extensions = {
        "aerial",
        "fzf",
        "man",
        "mason",
        "neo-tree",
        "nvim-dap-ui",
        "oil",
        "overseer",
        "quickfix",
        "trouble",
    },
})

--+- Behaviour: Auto Rename Tabs ----------------------------+
require("_config.util.lazy").on_module("resession", function()
    require("resession").add_hook("post_load", function()
        local tcd = vim.fn.fnamemodify(vim.fn.getcwd(-1, 0), ":t")
        pcall(vim.cmd, [[LualineRenameTab ]] .. tcd .. [[]])
    end)
end)

vim.api.nvim_create_autocmd({ "DirChanged" }, {
    pattern = "tabpage",
    group = vim.api.nvim_create_augroup("MyLualineTabRenameTcd", { clear = true }),
    callback = function(event)
        local tcd = vim.fn.fnamemodify(vim.fn.getcwd(-1, 0), ":t")
        pcall(vim.cmd, [[LualineRenameTab ]] .. tcd .. [[]])
    end,
})

vim.api.nvim_create_autocmd({ "TabNewEntered" }, {
    group = vim.api.nvim_create_augroup("MyLualineTabRenameTab", { clear = true }),
    callback = function(event)
        vim.schedule(function()
            -- Wait for the tab to be fully initialized
            vim.defer_fn(function()
                -- Trigger the rename after a short delay
                local tcd = vim.fn.fnamemodify(vim.fn.getcwd(-1, 0), ":t")
                pcall(vim.cmd, [[LualineRenameTab ]] .. tcd .. [[]])
            end, 100)
        end)
    end,
})
