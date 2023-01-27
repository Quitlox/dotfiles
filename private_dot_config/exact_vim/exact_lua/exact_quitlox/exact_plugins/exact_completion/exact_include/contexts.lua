local cmp = require("cmp")


----------------------------------------
-- DAP
----------------------------------------
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

----------------------------------------
-- Filtetype: Python
----------------------------------------

cmp.setup.filetype("python", {
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- rank python completions starting with underscore last
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

----------------------------------------
-- Filtetype: Python
----------------------------------------
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = "buffer" },
    }),
})

----------------------------------------
-- Commandline (Path)
----------------------------------------
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Command Line Completion
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "cmdline_history" },
        { name = "path" },
    }),
})

-- Command Line Completion
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "cmdline_history" },
        { name = "path" },
    }),
})

