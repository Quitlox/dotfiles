local status_ok, zen_mode = require("quitlox.util").load_module("zen-mode")
if not status_ok then
	return
end
local status_ok, twilight = require("quitlox.util").load_module("twilight")
if not status_ok then
	return
end
local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

zen_mode.setup({
	kitty = {
		enabled = true,
		font = "+2",
	},
})

twilight.setup({
	dimming = {
		alpha = 0.5,
	},
	exclude = {},
})

wk.register({
	name = "Toggle",

	z = { "<cmd>ZenMode<cr>", "Toggle Zenmode" },
}, { prefix = "<leader>T" })
