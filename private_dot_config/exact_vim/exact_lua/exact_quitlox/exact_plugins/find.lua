local status_ok, actions = require("quitlox.util").load_module("telescope.actions")
if not status_ok then
	return
end

----------------------------------------
-- Setup
----------------------------------------

import("telescope", function(telescope)
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
end)

----------------------------------------
-- KEYBINDING: FIND
----------------------------------------

import("which-key", function(wk)
	wk.register({
		["<leader>"] = {
			f = {
				name = "Find",
				a = { "<cmd>Telescope live_grep theme=dropdown<cr>", "Find All" },
				f = { "<cmd>Telescope frecency theme=dropdown<cr>", "Find File" },
				b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
				r = { "<cmd>Telescope lsp_references<cr>", "Find References" },
				d = { "<cmd>Telescope diagnostics<cr>", "Find Diagnostics" },
				i = { "<cmd>Telescope lsp_implementations<cr>", "Find Implementations" },
				y = { "<cmd>Telescope lsp_type_definitions<cr>", "Find type definitions" },
				t = { "<cmd>Telescope tags<cr>", "Find type definitions" },
				m = { "<cmd>Telescope man_pages theme=dropdown <cr>", "Find Manpage" },
				h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "Find Help" },
				s = {
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({ ignore_symbols = { "variable" } })
					end,
					"Find Symbols",
				},
			},
			o = {
				name = "Open",
				f = { "<cmd>Telescope frecency theme=dropdown<cr>", "Open File" },
				s = {
					function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols({ ignore_symbols = { "variable" } })
					end,
					"Open Symbols",
				},
				g = {
					name = "Git",
					b = { "<cmd>Telescope git_branches<cr>", "Open Git Branches" },
					s = { "<cmd>Telescope git_status<cr>", "Open Git Status" },
				},
			},
		},
	})
end)
