-- +---------------------------------------------------------+
-- | catppuccin/nvim: Colorscheme                            |
-- +---------------------------------------------------------+
local success, mod = pcall(require, "catppuccin")
if not success then
    return
end

vim.cmd([[packadd catppuccin]]) -- silly name of catppuccin.nvim

--+- Kitty Integartion --------------------------------------+
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = vim.api.nvim_create_augroup("MyColorschemeSetup", { clear = true }),
    callback = function()
        -- If terminal is kitty, set the background to transparent
        if (vim.env.TERM == "kitty" or vim.env.TERM == "xterm-kitty") and vim.env.KITTY_WINDOW_ID and vim.env.KITTY_LISTEN_ON then
            local mocha = require("catppuccin.palettes").get_palette("mocha")
            vim.system({ "kitty", "@", "set-spacing", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "margin=0" }, { text = true }):wait()
            vim.system({ "kitty", "@", "set-colors", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "background='" .. mocha.base .. "'" }, { text = true }):wait()
            vim.system({ "kitty", "@", "set-background-opacity", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "1.0" }, { text = true }):wait()
        end
    end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    group = vim.api.nvim_create_augroup("MyColorschemeCleanup", { clear = true }),
    callback = function()
        -- If terminal is kitty, set the background to transparent
        if (vim.env.TERM == "kitty" or vim.env.TERM == "xterm-kitty") and vim.env.KITTY_WINDOW_ID and vim.env.KITTY_LISTEN_ON then
            local mocha = require("catppuccin.palettes").get_palette("mocha")
            vim.system({ "kitty", "@", "load-config", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON }, { text = true })
            vim.system({ "kitty", "@", "set-spacing", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "margin=15" }, { text = true })
            vim.system({ "kitty", "@", "set-colors", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "background='" .. "#1f2731" .. "'" }, { text = true }):wait()
            vim.system({ "kitty", "@", "set-background-opacity", "--match", "id:" .. vim.env.KITTY_WINDOW_ID, "--to=" .. vim.env.KITTY_LISTEN_ON, "0.6" }, { text = true }):wait()
        end
    end,
})

--+- Setup --------------------------------------------------+
require("catppuccin").setup({
    transparent_background = false,
    term_colors = true,
    -- show_end_of_buffer = false,

    integrations = {
        aerial = true,
        blink_cmp = true,
        copilot_vim = true,
        diffview = true,
        fidget = true,
        grug_far = true,
        harpoon = true,
        leap = true,
        lsp_trouble = true,
        mason = true,
        markview = true,
        mini = { enabled = true },
        neotree = true,
        neogit = true,
        neotest = true,
        notify = true,
        navic = { enabled = true },
        nvim_surround = true,
        octo = true,
        overseer = true,
        semantic_tokens = true,
        snacks = { enabled = true },
        ufo = true,
        which_key = true,
        window_picker = true,

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
            inlay_hints = {
                background = false,
            },
        },
    },

    highlight_overrides = {
        all = function(colors)
            return {
                NeoTreeCursorLine = { style = { "bold" } },
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
vim.cmd.colorscheme("catppuccin")

-- +---------------------------------------------------------+
-- | rachartier/tiny-devicons-auto-colors.nvim: Color       |
-- | Devicons based on the colorscheme                       |
-- +---------------------------------------------------------+

local theme_colors = require("catppuccin.palettes").get_palette("mocha")

require("nvim-web-devicons").setup({
    color_icons = true,
})

-- Globally pad icons with a space
-- Devicons = require("nvim-web-devicons")
-- local get_icon = Devicons.get_icon
-- Devicons.get_icon = function(name, ext, opts)
--     local icon, hl = get_icon(name, ext, opts)
--     if icon ~= nil then return icon .. " ", hl end
-- end

require("tiny-devicons-auto-colors").setup({ colors = theme_colors, autoreload = true })
