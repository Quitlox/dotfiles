-- Vim Options
vim.o.background = "dark"

local highlights = {
    fill = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
    },
    background = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
    },
    buffer_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
    },
    buffer_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
    },
    separator = {
        fg = { attribute = "bg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
    },
    separator_selected = {
        fg = { attribute = "fg", highlight = "Special" },
        bg = { attribute = "bg", highlight = "Normal" },
    },
    separator_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
    },
    close_button = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
    },
    close_button_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
    },
    close_button_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
    },
}

return {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
        local c = require("vscode.colors").get_colors()

        require("vscode").setup({
            transparent = false,
            italic_comments = true,
            disable_nvimtree_bg = false,
            -- Override highlight groups (see ./lua/vscode/theme.lua)
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
            },
            highlights = highlights,

        })

        vim.cmd([[colorscheme vscode]])

        ----------------------------------------
        -- Customization
        ----------------------------------------

        -- Fix fidget background
        vim.cmd([[hi! link FidgetTask Normal]])
        -- Explorer
        vim.cmd([[hi NvimTreeOpenedFile guifg=]] .. c.vscMediumBlue)
        -- Trouble
        vim.cmd([[hi! link TroubleCode @field]])
        vim.cmd([[hi! link TroubleSource @field]])
        -- Git Blame
        vim.cmd([[hi! link gitblame GitSignsCurrentLineBlame]])

        -- Spelling Highlight
        -- xtermcolors: https://www.ditig.com/256-colors-cheat-sheet
        vim.cmd([[hi SpellBad guifg=None guibg=None guisp='DarkOliveGreen3' gui=undercurl]])
        vim.cmd([[hi SpellCap guifg=None guibg=None guisp='Olive' gui=undercurl]])
        vim.cmd([[hi SpellRare guifg=None guibg=None guisp='Olive' gui=undercurl]])
        vim.cmd([[hi SpellLocal guifg=None guibg=None guisp='Olive' gui=undercurl]])

        ----------------------------------------
        -- Highlighted Yank
        ----------------------------------------
        -- Highlighting Yank is now built into Neovim!
        vim.cmd(
            [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=500} ]]
        )
    end,
}
