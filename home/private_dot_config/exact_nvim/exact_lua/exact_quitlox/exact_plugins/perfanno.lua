-- +---------------------------------------------------------+
-- | t-troebst/perfanno.nvim: Profile Neovim                 |
-- +---------------------------------------------------------+

local perfanno = require("perfanno")
local util = require("perfanno.util")

local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")

perfanno.setup({
    -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
    line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
    vt_highlight = util.make_fg_highlight("#CC3300"),
})

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<localleader>plf", ":PerfLoadFlat<CR>", opts)
keymap("n", "<localleader>plg", ":PerfLoadCallGraph<CR>", opts)
keymap("n", "<localleader>plo", ":PerfLoadFlameGraph<CR>", opts)

keymap("n", "<localleader>pe", ":PerfPickEvent<CR>", opts)

keymap("n", "<localleader>pa", ":PerfAnnotate<CR>", opts)
keymap("n", "<localleader>pf", ":PerfAnnotateFunction<CR>", opts)
keymap("v", "<localleader>pa", ":PerfAnnotateSelection<CR>", opts)

keymap("n", "<localleader>pt", ":PerfToggleAnnotations<CR>", opts)

keymap("n", "<localleader>ph", ":PerfHottestLines<CR>", opts)
keymap("n", "<localleader>ps", ":PerfHottestSymbols<CR>", opts)
keymap("n", "<localleader>pc", ":PerfHottestCallersFunction<CR>", opts)
keymap("v", "<localleader>pc", ":PerfHottestCallersSelection<CR>", opts)
