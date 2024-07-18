-- Highlight lua in viml
vim.g.vimsyn_embed = "l"

-- +---------------------------------------------------------+
-- | Options                                                 |
-- +---------------------------------------------------------+

vim.opt.fileformats = "unix,dos,mac"
--- Autoformatting / comment behaviour ---
vim.opt.formatoptions = vim.opt.formatoptions + "r" -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- vim.opt.formatoptions = vim.opt.formatoptions + "v" -- Vi-compatible auto-wrapping in insert mode: Only break a line at a blank that you have entered during the current insert command.
vim.opt.formatoptions = vim.opt.formatoptions + "p" -- Don't break lines at single spaces that follow periods.
vim.opt.formatoptions = vim.opt.formatoptions + "1" -- Don't break a line after a one-letter word.
--- Tab behaviour ---
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
--- Wrapping ---
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l"
vim.opt.breakindent = true -- WARNING: NEW
--- Cursor ---
vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 10
-- vim.opt.mat=2 -- Tenths of a second to show the matching paren
-- vim.opt.showmatch = true -- TODO: Do I need this (and line above)
vim.opt.cursorline = true
vim.opt.culopt = "number"
--- Searching ---
vim.opt.ignorecase = true
vim.opt.smartcase = true
--- Layout ---
vim.opt.signcolumn = "yes" -- Prevent the error gutter from moving the vertical separator
vim.opt.number = true
--- Drawing ---
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = vim.opt.fillchars + "eob: "
--- UI ---
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.g.have_nerd_font = true -- Maybe kickstart.nvim specific
-- vim.showtabline = 2 -- TODO: Is this necessary?
--- Splits ---
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.eadirection = "hor"
--- Title ---
vim.opt.title = true
vim.opt.titlestring = "neovim: %{fnamemodify(getcwd(),':t')} (%t) titlelen=70"
--- Spell ---
vim.opt.spell = true
vim.opt.spelllang = "en_us,nl"
--- Backup ---
vim.opt.undofile = true
vim.opt.backup = true
--- Misc ---
-- vim.opt.confirm = true TODO: Is this necessary?
vim.opt.updatetime = 250
vim.opt.timeoutlen = 800

-- +---------------------------------------------------------+
-- | Wildmenu                                                |
-- +---------------------------------------------------------+

if vim.fn.has("wildmenu") == 1 then
    vim.opt.wildmenu = true
    vim.opt.wildmode = "list,full" -- Was 'list:longest,full'
    vim.opt.wildignorecase = true

    -- Version Control
    vim.opt.wildignore:append(".git,.hg,.svn,.stversions,*.spl,")
    -- Temp files
    vim.opt.wildignore:append("*.o,*.out,*~,%*,Session.vim,")
    -- Misc. files
    vim.opt.wildignore:append("*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store")
    -- Web Dev
    vim.opt.wildignore:append("**/node_modules/**,**/bower_modules/**,*/.sass-cache/*,*.lock")
    -- Python
    vim.opt.wildignore:append("__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**,*.pyc,*.lock,")
    -- Latex
    vim.opt.wildignore:append("*.aux,*.bbl,*.bcf,*.blg,*.fls,*.log,*.run*.xml,*.synctex*.gz,*.fdb_latexmk,*.glg,*.glo,*.gls,*.ist,*.toc,*.glsdefs,*.tikzstyles")
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
