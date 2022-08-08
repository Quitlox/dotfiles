require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		-- Main Languages
		"c",
		"lua",
		"rust",
		"python",
		"java",
		-- Shell
		"vim",
		"bash",
		"cpp",
		-- Latex
		"latex",
		"bibtex",
		-- Build Environment
		"make",
		"cmake",
		"dockerfile",
		-- Supplemenatry Files
		"json",
		"jsonc",
		"markdown",
		"toml",
		"yaml",
		-- Web Development
		"graphql",
		"html",
		"scss",
		"sql",
		"tsx",
		"typescript",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	-- Rainbow Parantheses
	-- courtesy of p00f/nvim-ts-rainbow
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = 10000, -- Do not enable for files with more than n lines, int
	},
	indent = {
		enable = true,
		disable = { "python" },
	},
})

-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
-- 	group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
-- 	callback = function()
-- 		vim.opt.foldmethod = "expr"
-- 		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 	end,
-- })
---ENDWORKAROUND

----------------------------------------
-- Temp
----------------------------------------
-- Temporary plugin for Python indentation since the default treesitter implementation sucks.

require("nvim-treesitter.configs").setup({
	yati = { enable = true },
})
