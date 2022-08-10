local status_ok, nvim_tree = require("quitlox.util").load_module("nvim-tree")
if not status_ok then
	return
end

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

	diagnostics = {
		enable = true,
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
			enable = true,
		},
		highlight_opened_files = "all",
	},
	filters = {
		dotfiles = true,
	},

	live_filter = {
		prefix = "",
		always_show_folders = false,
	},
})

----------------------------------------
-- KEYBINDINGS: FIND
----------------------------------------

local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

wk.register({
	["<leader>"] = {
		f = {
			name = "find",
			l = { ":NvimTreeFindFile<cr>", "Find Location" },
		},
	},
})
