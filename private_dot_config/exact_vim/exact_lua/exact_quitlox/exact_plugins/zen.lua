require("zen-mode").setup({
	kitty = {
		enabled = true,
		font = "+2",
	},
})

require("twilight").setup({
	dimming = {
		alpha = 0.5,
	},
	exclude = {},
})

local wk = require("which-key")
wk.register({
	name = "Toggle",

	z = { "<cmd>ZenMode<cr>", "Toggle Zenmode" },
}, { prefix = "<leader>T" })
