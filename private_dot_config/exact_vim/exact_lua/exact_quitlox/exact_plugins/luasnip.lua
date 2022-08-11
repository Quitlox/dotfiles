---@diagnostic disable: undefined-global, unused-local

import("luasnip", function(ls)
    local s = ls.snippet
    local sn = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node

	ls.add_snippets("lua", {
		s("fn", {
			t("function("),
			i(1, "arg"),
			t(") "),
			i(2),
			t(" end"),
		}),
	})
end)
