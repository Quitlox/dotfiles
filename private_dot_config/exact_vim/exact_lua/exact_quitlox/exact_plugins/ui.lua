----------------------------------------
-- Language Support: User Interface
----------------------------------------

require("dressing").setup({
	input = {
		-- Default prompt string
		default_prompt = "Input:",

		-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		prefer_width = 40,
		width = nil,
		-- min_width and max_width can be a list of mixed types.
		-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
		max_width = { 140, 0.9 },
		min_width = { 20, 0.2 },

		-- Window transparency (0-100)
		winblend = 0,
		-- Change default highlight groups (see :help winhl)
		winhighlight = "",

		-- Set to `false` to disable
		mappings = {
			n = {
				["<Esc>"] = "Close",
				["<CR>"] = "Confirm",
			},
			i = {
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
				["<Up>"] = "HistoryPrev",
				["<Down>"] = "HistoryNext",
				["<C-p>"] = "HistoryPrev",
				["<C-n>"] = "HistoryNext",
			},
		},

		-- see :help dressing_get_config
		get_config = nil,
	},
	select = {
		-- Trim trailing `:` from prompt
		trim_prompt = true,

		-- Options for telescope selector
		-- These are passed into the telescope picker directly. Can be used like:
		-- telescope = require('telescope.themes').get_ivy({...})
		telescope = nil,

		-- Options for built-in selector
		builtin = {

			-- Window transparency (0-100)
			winblend = 0,
			-- Change default highlight groups (see :help winhl)
			winhighlight = "",

			-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- the min_ and max_ options can be a list of mixed types.
			-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
			width = nil,
			max_width = { 140, 0.8 },
			min_width = { 40, 0.2 },
			height = nil,
			max_height = 0.9,
			min_height = { 10, 0.2 },

			-- Set to `false` to disable
			mappings = {
				["<Esc>"] = "Close",
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
			},
		},

		-- Used to override format_item. See :help dressing-format
		format_item_override = {},

		-- see :help dressing_get_config
		get_config = nil,
	},
})
