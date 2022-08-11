import("zen-mode", function(zen_mode)
	zen_mode.setup({
		kitty = {
			enabled = true,
			font = "+2",
		},
	})
end)

import("twilight", function(twilight)
	twilight.setup({
		dimming = {
			alpha = 0.5,
		},
		exclude = {},
	})
end)

import("which-key", function(wk)
	wk.register({
		name = "Toggle",

		z = { "<cmd>ZenMode<cr>", "Toggle Zenmode" },
	}, { prefix = "<leader>T" })
end)
