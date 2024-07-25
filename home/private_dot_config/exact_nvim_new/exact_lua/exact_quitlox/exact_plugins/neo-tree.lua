-- +---------------------------------------------------------+
-- | nvim-neo-tree/neo-tree.nvim: File Explorer              |
-- +---------------------------------------------------------+

local ignore_ft = {
    "help",
    "Neogit",
    "NeogitStatus",
    "neotest-summary",
    "neo-tree",
    "neo-tree-popup",
    "notify",
    "Outline",
    "qf",
    "terminal",
    "trouble",
}

--+- Signs --------------------------------------------------+
-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint" })

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>lf", "<cmd>Neotree position=left source=filesystem reveal=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>oe", "<cmd>Neotree position=left source=filesystem reveal=false toggle=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>oo", "<cmd>Neotree position=right document_symbols reveal=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ls", "<cmd>Neotree position=right source=document_symbols reveal=true<cr>", { noremap = true, silent = true })

--+- Setup --------------------------------------------------+
require("neo-tree").setup({
    open_files_do_not_replace_types = ignore_ft,

    window = {
        mappings = {
            ["<cr>"] = "open_with_window_picker",
            ["o"] = { "open", silent = true, nowait = true },
            ["<esc>"] = "revert_preview",
            ["b"] = { "open_vsplit", nowait = true },
            ["v"] = { "open_split", nowait = true },
            ["s"] = "noop",
            ["S"] = "noop",
        },
    },

    filesystem = {
        -- for project.nvim
        bind_to_cwd = true,
        cwd_target = {
            sidebar = "tab",
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true,
    },
    document_symbols = {
        follow_cursor = true,
        window = {
            mappings = {
                ["<cr>"] = "jump_to_symbol",
                ["o"] = "toggle_node",
                ["i"] = "jump_to_symbol",
                ["A"] = "noop",
                ["d"] = "noop",
                ["y"] = "noop",
                ["x"] = "noop",
                ["p"] = "noop",
                ["c"] = "noop",
                ["m"] = "noop",
                ["a"] = "noop",
                ["/"] = "filter",
                ["f"] = "filter_on_submit",
            },
        },
    },

    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
    },

    source_selector = {
        winbar = true,
        statusline = false,
        sources = {
            {
                source = "filesystem",
                display_name = " 󰉓  Files ",
            },
            {
                source = "buffers",
                display_name = "   Buffers ",
            },
            {
                source = "git_status",
                display_name = " 󰊢  Git ",
            },
            -- {
            --     source = "document_symbols",
            --     display_name = "  Outline ",
            -- },
        },
    },
})

-- +---------------------------------------------------------+
-- | s1n7ax/nvim-window-picker                               |
-- +---------------------------------------------------------+

require("window-picker").setup({
    filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = ignore_ft,
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
        },
    },
})
