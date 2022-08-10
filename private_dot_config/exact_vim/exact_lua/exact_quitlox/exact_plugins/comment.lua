local status_ok, comment = require("quitlox.util").load_module("nvim_comment")
if not status_ok then
	return
end

comment.setup({
	comment_empty = false,
})
