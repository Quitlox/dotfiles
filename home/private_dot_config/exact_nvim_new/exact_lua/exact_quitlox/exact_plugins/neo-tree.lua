-- +---------------------------------------------------------+
-- | nvim-neo-tree/neo-tree.nvim: File Explorer              |
-- +---------------------------------------------------------+

local ignore_ft = {
    "edgy",
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
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint" })

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>lf", "<cmd>Neotree position=left source=filesystem reveal=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>oe", "<cmd>Neotree position=left source=filesystem reveal=false toggle=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>oo", "<cmd>Neotree position=right document_symbols reveal=true<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ls", "<cmd>Neotree position=right source=document_symbols reveal=true<cr>", { noremap = true, silent = true })

--+- Setup --------------------------------------------------+
require("neo-tree").setup({
    open_files_do_not_replace_types = ignore_ft,
    enable_diagnostics = false,

    default_component_configs = {
        container = {
            left_padding = 1, -- Padding after icon
        },
    },

    window = {
        mappings = {
            ["<cr>"] = { "open", silent = true, noremap = true },
            ["o"] = { "open_with_window_picker", silent = true, nowait = true },
            ["<esc>"] = "revert_preview",
            ["b"] = { "open_vsplit", nowait = true },
            ["v"] = { "open_split", nowait = true },
            ["s"] = "noop",
            ["S"] = "noop",
        },
    },

    filesystem = {
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true,
        components = {
            -- name = function(config, node, state)
            --     local highlight = config.highlight or highlights.FILE_NAME
            --     if node.type == "directory" then highlight = highlights.DIRECTORY_NAME end
            --     if node:get_depth() == 1 then
            --         highlight = highlights.ROOT_NAME
            --     else
            --         if config.use_git_status_colors == nil or config.use_git_status_colors then
            --             local git_status = state.components.git_status({}, node, state)
            --             if git_status and git_status.highlight then highlight = git_status.highlight end
            --         end
            --     end
            --     return {
            --         text = node.name,
            --         highlight = highlight,
            --     }
            -- end,
        },
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

        kinds = {
            Unknown = { icon = "? ", hl = "" },
            Root = { icon = " ", hl = "NeoTreeRootName" },
            File = { icon = " ", hl = "Tag" },
            Module = { icon = " ", hl = "Exception" },
            Namespace = { icon = "󰌗 ", hl = "Include" },
            Package = { icon = "󰏖 ", hl = "Label" },
            Class = { icon = "󰌗 ", hl = "Include" },
            Method = { icon = " ", hl = "Function" },
            Property = { icon = "󰆧 ", hl = "@property" },
            Field = { icon = " ", hl = "@field" },
            Constructor = { icon = " ", hl = "@constructor" },
            Enum = { icon = "󰒻 ", hl = "@number" },
            Interface = { icon = " ", hl = "Type" },
            Function = { icon = "󰊕 ", hl = "Function" },
            Variable = { icon = " ", hl = "@variable" },
            Constant = { icon = " ", hl = "Constant" },
            String = { icon = "󰀬 ", hl = "String" },
            Number = { icon = "󰎠 ", hl = "Number" },
            Boolean = { icon = " ", hl = "Boolean" },
            Array = { icon = "󰅪 ", hl = "Type" },
            Object = { icon = "󰅩 ", hl = "Type" },
            Key = { icon = "󰌋 ", hl = "" },
            Null = { icon = " ", hl = "Constant" },
            EnumMember = { icon = " ", hl = "Number" },
            Struct = { icon = "󰌗 ", hl = "Type" },
            Event = { icon = " ", hl = "Constant" },
            Operator = { icon = "󰆕 ", hl = "Operator" },
            TypeParameter = { icon = "󰊄 ", hl = "Type" },

            -- ccls
            -- TypeAlias = { icon = ' ', hl = 'Type' },
            -- Parameter = { icon = ' ', hl = '@parameter' },
            -- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
            -- Macro = { icon = ' ', hl = 'Macro' },
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
