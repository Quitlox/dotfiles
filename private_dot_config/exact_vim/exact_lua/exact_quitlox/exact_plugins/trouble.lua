local status_ok, trouble = require("quitlox.util").load_module("trouble")
if not status_ok then
	return
end

trouble.setup({
	action_keys = {
		close = "q",
		open_split = { "<c-v>" },
		open_vsplit = { "<c-b>" },
		toggle_fold = { "zA", "za", "o" },
	},
})

local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

wk.register({
	["<leader>"] = {
		o = {
			name = "Open",
			d = { "<cmd>Trouble<cr>", "Open Diagnostics" },
		},
	},
}, { noremap = true })
