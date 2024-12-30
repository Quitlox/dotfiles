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
        C = spec_treesitter({
            a = "@class.outer",
            i = "@class.inner",
        }),
        d = spec_treesitter({
            a = "@statement.outer",
            i = "@statement.inner",
        }),
        b = spec_treesitter({
            a = { "@loop.outer", "@block.outer" },
            i = { "@loop.inner", "@block.inner" },
        }),
    },
})
