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
			x = {
				name = "Open",
                x = {"<cmd>TroubleToggle<cr>", "Open Trouble"},
				d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Open Document Diagnostics" },
				w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Open Workspace Diagnostics" },
				q = { "<cmd>TroubleToggle quickfix_diagnostics<cr>", "Open Quickfix" },
			},
		},
	}, { noremap = true })
end)

