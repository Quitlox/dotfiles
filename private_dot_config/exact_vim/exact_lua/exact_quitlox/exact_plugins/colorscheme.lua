vim.o.background = "dark"

local c = require("vscode.colors")

require("vscode").setup({
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

-- Fix fidget background
-- vim.cmd([[hi! link FidgetTask Normal]])

----------------------------------------
-- Customization
----------------------------------------

-- Explorer
vim.cmd([[hi NvimTreeOpenedFile guifg=]] .. c.vscMediumBlue)
-- Spellcheck
vim.cmd([[hi SpellBad guifg=None gui=undercurl guisp=]] .. c.vscContextCurrent)

----------------------------------------
-- Highlighted Yank
----------------------------------------
-- Highlighting Yank is now built into Neovim!

vim.cmd([[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
    augroup END
]])