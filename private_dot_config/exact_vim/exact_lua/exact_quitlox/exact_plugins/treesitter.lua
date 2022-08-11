require("nvim-treesitter.configs").setup({
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

	----- Highlight -----
	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},

	----- Rainbow -----
	-- with: p00f/nvim-ts-rainbow
	rainbow = {
		enable = true,
		extended_mode = false,
		max_file_lines = 20000,
		-- disable = { "jsx", "cpp" }
	},

	----- Indenting -----
	indent = {
		enable = true,
		-- See yati below
		disable = { "python" },
	},
	-- Temporary plugin for Python indentation
	-- since the default treesitter implementation sucks.
	yati = { enable = true },

	----- Text Objects -----
	-- with: nvim-treesitter/nvim-treesitter-textobjects
	textobjects = {
		move = {
			goto_next_start = {
				["]f"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
			-- You can choose the select mode (default is charwise 'v')
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
		},
	},
})
