return {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
        show_in_active_only = true,
        excluded_buftypes = {
            "terminal",
        },
        excluded_filetypes = {
            "prompt",
            "TelescopePrompt",
            "noice",
            "dap-repl",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_watches",
            "lazy",
        },
        handlers = {
            cursor = true,
            diagnostic = true,
            gitsigns = true,
            handle = true,
            search = false,
            ale = false,
        },
        marks = {
            Info = { text = { "" } },
            Hint = { text = { "" } },
        },
    },
}
