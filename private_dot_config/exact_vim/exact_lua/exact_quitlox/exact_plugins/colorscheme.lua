----------------------------------------
-- Colorscheme: Vim Options
----------------------------------------

-- Vim Options
vim.o.background = "dark"

----------------------------------------
-- Colorscheme: Setup
----------------------------------------

import("vscode", function(vscode)
    local c = require("vscode.colors")

    vscode.setup({
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = false,

        -- group_overrides = {
        -- 	-- WhichKeyFloat = { bg = c.vscNone, fg = c.vscNone },
        -- 	-- NormalFloat = { bg = c.vscNone, fg = c.vscNone },
        --
        -- 	-- Normal = { bg = c.vscNone, fg = c.vscNone },
        -- 	-- BufferLineSeparator = { bg = c.vscNone, fg = c.vscNone },
        -- 	-- BufferLineBackground = { bg = c.vscNone, fg = c.vscNone },
        -- },
    })

    -- require("transparent").setup({
    -- 	enable = false,
    -- 	extra_groups = {
    -- 		-- example of akinsho/nvim-bufferline.lua
    -- 		-- "BufferLineTabClose",
    -- 		-- "BufferlineBufferSelected",
    -- 		-- "BufferLineFill",
    -- 		-- "BufferLineBackground",
    -- 		-- "BufferLineSeparator",
    -- 		-- "BufferLineIndicatorSelected",
    -- 	},
    -- 	exclude = {},
    -- })

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

    -- Spellcheck
    -- TODO order is wrong
    -- vim.cmd([[hi SpellBad guifg=None guibg=None gui=undercurl guisp=None]] .. c.vscContextCurrent)

    ----------------------------------------
    -- Highlighted Yank
    ----------------------------------------
    -- Highlighting Yank is now built into Neovim!
    vim.cmd([[
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=500}
]]   )
end)
