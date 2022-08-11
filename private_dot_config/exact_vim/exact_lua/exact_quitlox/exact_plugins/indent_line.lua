vim.opt.list = true

local status_ok, indent_blankline = require("quitlox.util").load_module("indent_blankline")
if not status_ok then
	return
end

indent_blankline.setup({
	show_current_context = true,
	show_current_context_start = false,
	show_end_of_line = false,
})
