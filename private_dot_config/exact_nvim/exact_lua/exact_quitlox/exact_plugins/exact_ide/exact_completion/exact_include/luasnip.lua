----------------------------------------------------------------------
--                             LuaSnip                              --
----------------------------------------------------------------------
-- LuaSnip is used as the snippet engine
-- It is configured to work nicely together with nvim-cmp

local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local r = ls.restore_node

vim.keymap.set("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
vim.keymap.set("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
vim.keymap.set("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
vim.keymap.set("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

ls.config.setup({ enable_autosnippets = true })
ls.add_snippets("lua", {
    s("fn", {
        t("function("),
        i(1, "arg"),
        t(") "),
        i(2),
        t(" end"),
    }),
})

require('luasnip.loaders.from_snipmate').lazy_load()
