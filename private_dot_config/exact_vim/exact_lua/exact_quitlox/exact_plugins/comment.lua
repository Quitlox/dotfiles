
----------------------------------------------------------------------
--                             Comment                              --
----------------------------------------------------------------------

import("nvim_comment", function(comment)
	comment.setup({
		comment_empty = false,
	})
end)

----------------------------------------------------------------------
--                          Comment Frame                           --
----------------------------------------------------------------------

import({"nvim-comment-frame", "which-key"}, function(modules)
    local wk = modules["which-key"]
    local frame = modules["nvim-comment-frame"]

    frame.setup()
    wk.register({
        f = {frame.add_comment, "Comment Frame"},
        F = {frame.add_multiline_comment, "Comment Frame (multi-line)"},

    },{prefix="gc"})

end)
