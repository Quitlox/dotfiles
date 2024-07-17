-- Highlight lua in viml
vim.g.vimsyn_embed = "l"

-- +---------------------------------------------------------+
-- | Options                                                 |
-- +---------------------------------------------------------+

vim.o.fileformats = "unix,dos,mac"
--- Autoformatting / comment behaviour ---
vim.o.formatoptions = vim.o.formatoptions + "r" -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- vim.o.formatoptions = vim.o.formatoptions + "v" -- Vi-compatible auto-wrapping in insert mode: Only break a line at a blank that you have entered during the current insert command.
vim.o.formatoptions = vim.o.formatoptions + "p" -- Don't break lines at single spaces that follow periods.
vim.o.formatoptions = vim.o.formatoptions + "1" -- Don't break a line after a one-letter word.
--- Tab behaviour ---
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
--- Wrapping ---
vim.o.wrap = false
vim.o.linebreak = true
vim.o.whichwrap = vim.o.whichwrap + "<,>,h,l"
vim.o.breakindent = true -- WARNING: NEW
--- Cursor ---
vim.o.scrolloff = 7
vim.o.sidescrolloff = 10
-- vim.o.mat=2 -- Tenths of a second to show the matching paren
-- vim.o.showmatch = true -- TODO: Do I need this (and line above)
vim.o.cursorline = true
vim.o.culopt = "number"
--- Searching ---
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = true -- Show live preview of :s
--- Layout ---
vim.o.signcolumn = "yes" -- Prevent the error gutter from moving the vertical separator
vim.o.number = true
--- Drawing ---
vim.o.list = true
vim.o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.fillchars = vim.o.fillchars + "eob: "
--- UI ---
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.g.have_nerd_font = true -- Maybe kickstart.nvim specific
-- vim.showtabline = 2 -- TODO: Is this necessary?
--- Splits ---
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.eadirection = "hor"
--- Title ---
vim.o.title = true
vim.o.titlestring = "neovim: %{fnamemodify(getcwd(),':t')} (%t) titlelen=70"
--- Spell ---
vim.o.spell = true
vim.o.spelllang = "en_us,nl"
--- Backup ---
vim.o.undofile = true
vim.o.backup = true
--- Misc ---
-- vim.o.confirm = true TODO: Is this necessary?
vim.o.updatetime = 250
vim.o.timeoutlen = 800

-- +---------------------------------------------------------+
-- | Wildmenu                                                |
-- +---------------------------------------------------------+

if vim.fn.has("wildmenu") == 1 then
	vim.o.wildmenu = true
	vim.o.wildmode = "list,full" -- Was 'list:longest,full'
	vim.o.wildignorecase = true

	-- Version Control
	vim.o.wildignore = vim.o.wildignore + ".git,.hg,.svn,.stversions,*.spl,"
	-- Temp files
	vim.o.wildignore = vim.o.wildignore + "*.o,*.out,*~,%*,Session.vim,"
	-- Misc. files
	vim.o.wildignore = vim.o.wildignore + "*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store"
	-- Web Dev
	vim.o.wildignore = vim.o.wildignore + "**/node_modules/**,**/bower_modules/**,*/.sass-cache/*,*.lock"
	-- Python
	vim.o.wildignore = vim.o.wildignore + "__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**,*.pyc,*.lock,"
	-- Latex
	vim.o.wildignore = vim.o.wildignore
		+ "*.aux,*.bbl,*.bcf,*.blg,*.fls,*.log,*.run*.xml,*.synctex*.gz,*.fdb_latexmk,*.glg,*.glo,*.gls,*.ist,*.toc,*.glsdefs,*.tikzstyles"
end

-- +---------------------------------------------------------+
-- | Special Cases                                           |
-- +---------------------------------------------------------+

-- Disable undo in temporary files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
	group = vim.api.nvim_create_augroup("QuitloxUndo", { clear = true }),
	command = "setlocal noundofile",
})

-- Never insert comments when pressing o or O
-- The standard ftplugin usually overwrite this,
-- so it has to be an autocmd.
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "*",
	group = vim.api.nvim_create_augroup("QuitloxFormatOptionO", { clear = true }),
	command = "setlocal formatoptions-=o",
})

-- +---------------------------------------------------------+
-- | Filetype Specific Options                               |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json", "jsonc" },
	command = "setconceallevel=0",
})
