-- +---------------------------------------------------------+
-- | catppuccin/nvim: Colorscheme                            |
-- +---------------------------------------------------------+
if not pcall(require, "catppuccin") then return end

vim.cmd([[packadd nvim]]) -- silly name of catppuccin.nvim
vim.cmd([[packadd tiny-devicons-auto-colors.nvim]])

--+- Kitty Integartion --------------------------------------+
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = vim.api.nvim_create_augroup("MyColorschemeSetup", { clear = true }),
    callback = function()
        -- If terminal is kitty, set the background to transparent
        if vim.env.TERM == "kitty" or vim.env.TERM == "xterm-kitty" then
            local mocha = require("catppuccin.palettes").get_palette("mocha")
            vim.system({ "kitty", "@", "set-spacing", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "margin=0" }, { text = true })
            vim.system({ "kitty", "@", "set-colors", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "background='" .. mocha.base .. "'" })
            vim.system({ "kitty", "@", "set-background-opacity", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "1.0" })
        end
    end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    group = vim.api.nvim_create_augroup("MyColorschemeCleanup", { clear = true }),
    callback = function()
        -- If terminal is kitty, set the background to transparent
        if vim.env.TERM == "kitty" or vim.env.TERM == "xterm-kitty" then
            local mocha = require("catppuccin.palettes").get_palette("mocha")
            vim.system({ "kitty", "@", "load-config" }, { text = true })
            vim.system({ "kitty", "@", "set-spacing", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "margin=15" }, { text = true })
        end
    end,
})

--+- Setup --------------------------------------------------+
require("catppuccin").setup({
    transparent_background = false,
    -- show_end_of_buffer = false,

    integrations = {
        fidget = true,
        harpoon = true,
        leap = true,
        mason = true,
        neotree = true,
        neotest = true,
        notify = true,
        ts_rainbow2 = true,
        window_picker = true,
        octo = true,
        overseer = true,
        which_key = true,

        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = {},
                hints = {},
                warnings = {},
                information = {},
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
    },

    highlight_overrides = {
        all = function(colors)
            return {
                NeoTreeCursorLine = { style = { "bold" } },
                -- WinSeparator = { bg = colors.base, fg = colors.base },
                EdgyTitle = { bg = colors.crust, fg = colors.blue, style = { "bold" } },
                EdgyWinBar = { bg = colors.crust },
                EdgyIconActive = { bg = colors.crust, fg = colors.peach },
                -- Not working for some reason
                -- ScrollbarHandle = { bg = colors.peach, fg = colors.peach },
                -- ScrollbarCursorHandle = { bg = colors.peach, fg = colors.peach },
            }
        end,
    },
})

-- Set colorscheme
vim.cmd([[colorscheme catppuccin]])

-- +---------------------------------------------------------+
-- | rachartier/tiny-devicons-auto-colors.nvim: Color       |
-- | Devicons based on the colorscheme                       |
-- +---------------------------------------------------------+

require("tiny-devicons-auto-colors").setup()
