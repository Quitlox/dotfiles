import("trouble", function(trouble)
	trouble.setup({
		action_keys = {
			close = "q",
			open_split = { "<c-v>" },
			open_vsplit = { "<c-b>" },
			toggle_fold = { "zA", "za", "o" },
		},
	})
end)

import("which-key", function(wk)
	wk.register({
		["<leader>"] = {
			o = {
				name = "Open",
				d = { "<cmd>Trouble<cr>", "Open Diagnostics" },
			},
		},
	}, { noremap = true })
end)
