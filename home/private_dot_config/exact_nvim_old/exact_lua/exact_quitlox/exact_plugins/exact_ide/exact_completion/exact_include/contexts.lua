local cmp = require("cmp")

----------------------------------------
-- DAP
----------------------------------------
-- TODO: Move to cmp-dap
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

----------------------------------------
-- Filtetype: Python
----------------------------------------

-- TODO: Move to python
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
-- Filtetype: Git
----------------------------------------
cmp.setup.filetype({ "NeogitCommitMessage", "gitcommit", "octo" }, {
    sources = cmp.config.sources({
        { name = "git" },
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
        { name = "path" },
        { name = "cmdline" },
        -- { name = "cmdline_history" },
    }),
})
