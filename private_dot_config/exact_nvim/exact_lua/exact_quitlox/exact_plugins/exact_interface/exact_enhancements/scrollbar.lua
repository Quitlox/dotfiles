return {
    "petertriho/nvim-scrollbar",
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
        },
        handlers = {
            cursor = true,
            diagnostic = true,
            gitsigns = true,
            handle = true,
            search = false,
            ale = false,
        },
    },
}
