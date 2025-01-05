-- +---------------------------------------------------------+
-- | mini.align: Enhance the `a` and `i` operators           |
-- +---------------------------------------------------------+
-- Implement the `a` and `i` operators. The mini.ai plugin provides the
-- functionality of `targets.vim` (a simpler algorithm based plugin for
-- brackets, separators and arguments) and nvim-treesitter-textobjects, which
-- provides queries for integration with textobjects.

-- The `mini.ai` plugin uses the queries provided by
-- nvim-treesitter-textobjects, so that plugin is a dependency.

local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
    custom_textobjects = {
        f = spec_treesitter({
            a = "@function.outer",
            i = "@function.inner",
        }),
        c = spec_treesitter({
            a = "@class.outer",
            i = "@class.inner",
        }),
        l = spec_treesitter({
            a = "@statement.outer",
            i = "@statement.inner",
        }),
        o = spec_treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        -- a = spec_treesitter({
        --     a = { "@attribute.outer", "@parameter.outer" },
        --     i = { "@attribute.inner", "@parameter.inner" },
        -- }),
    },
})

-- NOTE: Filetype specific textobjects currently configured in:
-- - ftplugin/python.lua

-- Integration: Which-Key ---------------------------------+
-- Stolen from LazyVim to show the textobjects in which-key
-- Note that due to the inherent design of `mini.ai`, this only works
-- after the which-key window is open. Quickly pressing e.g. "da" will
-- enter into the waiting mode of `mini.ai`.

---@type table<string, string|table>
local i = {
    [" "] = "Whitespace",
    ['"'] = 'Balanced "',
    ["'"] = "Balanced '",
    ["`"] = "Balanced `",
    ["("] = "Balanced (",
    [")"] = "Balanced ) including white-space",
    [">"] = "Balanced > including white-space",
    ["<lt>"] = "Balanced <",
    ["]"] = "Balanced ] including white-space",
    ["["] = "Balanced [",
    ["}"] = "Balanced } including white-space",
    ["{"] = "Balanced {",
    ["?"] = "User Prompt",
    _ = "Underscore",
    a = "Argument, Parameter",
    b = "Bracket", -- b = "Balanced ), ], }",
    c = "Class",
    l = "Statement",
    f = "Function",
    o = "Block, conditional, loop",
    q = "Quote", -- q = "Quote `, ', \"",
    t = "Tag",
}
local a = vim.deepcopy(i)
for k, v in pairs(a) do
    a[k] = v:gsub(" including.*", "")
end

local ic = vim.deepcopy(i)
local ac = vim.deepcopy(a)
for key, name in pairs({ n = "Next", l = "Last" }) do
    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
end
require("which-key").register({
    mode = { "o", "x" },
    i = i,
    a = a,
})
