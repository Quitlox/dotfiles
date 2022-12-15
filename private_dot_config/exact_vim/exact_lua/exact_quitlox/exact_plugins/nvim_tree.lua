import("nvim-tree", function(nvim_tree)
	nvim_tree.setup({
		disable_netrw = true,
		open_on_setup = true,
		open_on_setup_file = true,
		open_on_tab = true,
		hijack_cursor = true,
		sync_root_with_cwd = true,

		update_focused_file = {
			enable = true,
		},

        actions = {
            open_file = {
                -- Ensure that when nvim-tree.api.tree.open is called, the tree
                -- is not resized (happens when exiting DapUI)
                resize_window = true,
            }
        },

		diagnostics = {
			enable = true,
            icons = {
                hint = " ",
                info = " ",
            }
		},

		view = {
			mappings = {
				list = {
					{ key = "v", action = "split" },
					{ key = "b", action = "vsplit" },
				},
			},
		},
		renderer = {
			group_empty = true,
			icons = { webdev_colors = false, git_placement = "after" },
			indent_markers = {
				enable = false,
			},
			highlight_opened_files = "all",
		},
		filters = {
			dotfiles = true,
            custom = { "*.lock" }
		},

		live_filter = {
			prefix = "",
			always_show_folders = false,
		},
	})
end)

----------------------------------------
-- KEYBINDINGS: FIND
----------------------------------------

import("which-key", function(wk)
	wk.register({
		["<leader>"] = {
			f = {
				name = "find",
				l = { ":NvimTreeFindFile<cr>", "Find Location" },
			},
		},
	})
end)
