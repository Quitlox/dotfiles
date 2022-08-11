
local status_ok, telescope = require("quitlox.util").load_module("telescope")
if not status_ok then
	return
end
local status_ok, actions = require("quitlox.util").load_module("telescope.actions")
if not status_ok then
	return
end

----------------------------------------
-- Setup
----------------------------------------

telescope.setup({
	defaults = {
		path_display = { "smart", "truncate" },
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-v>"] = actions.select_horizontal,
				["<C-b>"] = actions.select_vertical,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		frecency = {
			theme = "dropdown",
			db_safe_mode = false,
			default_workspace = "CWD",
			show_unindexed = false,
			-- show_scores=true,
		},
	},
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("fzf")
telescope.load_extension("frecency")

----------------------------------------
-- KEYBINDING: OPEN
----------------------------------------

local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

wk.register({
	["<leader>"] = {
		o = {
			name = "Open",
			f = { "<cmd>Telescope frecency theme=dropdown<cr>", "Open File" },
			b = { "<cmd>Telescope buffers<cr>", "Open Buffer" },
			s = {
				function(query)
					require("telescope.builtin").lsp_dynamic_workspace_symbols({ ignore_symbols = { "variable" } })
				end,
				"Open Symbols",
			},
			r = { "<cmd>Telescope lsp_references<cr>", "Open References" },
			d = { "<cmd>Telescope diagnostics<cr>", "Open Diagnostics" },
			i = { "<cmd>Telescope lsp_implementations<cr>", "Open Implementations" },
			y = { "<cmd>Telescope lsp_type_definitions<cr>", "Open type definitions" },
			t = { "<cmd>Telescope tags<cr>", "Open type definitions" },
			m = { "<cmd>Telescope man_pages theme=dropdown <cr>", "Open Manpage" },
			h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "Open Help" },

			g = {
				name = "Git",
				b = { "<cmd>Telescope git_branches<cr>", "Open Git Branches" },
				s = { "<cmd>Telescope git_status<cr>", "Open Git Status" },
			},
		},
	},
})

----------------------------------------
-- KEYBINDINGS: FIND
----------------------------------------

wk.register({
	["<leader>"] = {
		f = {
			name = "Find",
			a = { "<cmd>Telescope live_grep theme=dropdown<cr>", "[f]ind [a]ll" },
		},
	},
})
