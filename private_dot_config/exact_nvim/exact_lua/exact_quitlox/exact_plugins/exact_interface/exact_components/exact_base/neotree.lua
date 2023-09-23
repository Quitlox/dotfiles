return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        init = function()
            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
        end,
        opts = {
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "rounded",

            enable_git_status = true,
            enable_diagnostics = true,

            open_files_do_not_replace_types = { "terminal", "trouble", "qf", "Neogit" },
            sort_case_insensitive = false, -- used when sorting files and directories in the tree

            default_component_configs = {
                container = {
                    enable_character_fade = true,
                },
                indent = {
                    indent_size = 2,
                    padding = 1, -- extra padding on left hand side
                    -- indent guides
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    highlight = "NeoTreeIndentMarker",
                    -- expander config, needed for nesting files
                    with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                modified = {
                    symbol = "[+]",
                    highlight = "NeoTreeModified",
                },
                name = {
                    trailing_slash = false,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
            },
            -- A list of functions, each representing a global custom command
            -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
            -- see `:h neo-tree-global-custom-commands`
            commands = {},
            window = {
                position = "left",
                width = 40,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<space>"] = {
                        "toggle_node",
                        nowait = false,
                    },

                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = "open_with_window_picker",
                    ["o"] = "open_with_window_picker",

                    ["<esc>"] = "revert_preview",
                    ["P"] = { "toggle_preview" },

                    ["l"] = "focus_preview",
                    ["v"] = "open_split",
                    ["b"] = "open_vsplit",

                    ["t"] = "open_tabnew",
                    -- ["<cr>"] = "open_drop",
                    -- ["t"] = "open_tab_drop",

                    ["w"] = "open_with_window_picker",
                    --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing

                    ["C"] = "close_node",
                    -- ['C'] = 'close_all_subnodes',

                    ["z"] = "close_all_nodes",
                    --["Z"] = "expand_all_nodes",

                    ["a"] = {
                        "add",
                        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                        config = {
                            show_path = "none", -- "none", "relative", "absolute"
                        },
                    },
                    ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["c"] = "copy",
                    ["m"] = "move",
                    ["q"] = "close_window",
                    ["R"] = "refresh",

                    ["<"] = "prev_source",
                    [">"] = "next_source",

                    ["g?"] = "show_help",
                },
            },
            nesting_rules = {},

            filesystem = {
                filtered_items = {
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        --"node_modules"
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        --"*.meta",
                        --"*/src/*/tsconfig.json",
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        --".gitignored",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        --".DS_Store",
                        --"thumbs.db"
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        ".null-ls_*",
                    },
                },
                follow_current_file = {
                    enabled = false, -- This will find and focus the file in the active buffer every
                },
                -- time the current file is changed while the tree is open.
                group_empty_dirs = true,
                hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree

                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["H"] = "toggle_hidden",
                        ["/"] = "fuzzy_finder",
                        ["D"] = "fuzzy_finder_directory",
                        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                        -- ["D"] = "fuzzy_sorter_directory",
                        ["f"] = "filter_on_submit",
                        ["<c-x>"] = "clear_filter",
                        ["[g"] = "prev_git_modified",
                        ["]g"] = "next_git_modified",
                    },
                    fuzzy_finder_mappings = {
                        -- define keymaps for filter popup window in fuzzy_finder_mode
                        ["<down>"] = "move_cursor_down",
                        ["<C-n>"] = "move_cursor_down",
                        ["<up>"] = "move_cursor_up",
                        ["<C-p>"] = "move_cursor_up",
                    },
                },

                commands = {}, -- Add a custom command or override a global one using the same function name
            },
            buffers = {
                follow_current_file = {
                    enabled = true, -- This will find and focus the file in the active buffer every
                },
                -- time the current file is changed while the tree is open.
                group_empty_dirs = true, -- when true, empty folders will be grouped together
                show_unloaded = true,
                window = {
                    mappings = {
                        ["bd"] = "buffer_delete",
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                    },
                },
            },
            git_status = {
                window = {
                    position = "float",
                    mappings = {
                        ["A"] = "git_add_all",
                        ["gu"] = "git_unstage_file",
                        ["ga"] = "git_add_file",
                        ["gr"] = "git_revert_file",
                        ["gc"] = "git_commit",
                        ["gp"] = "git_push",
                        ["gg"] = "git_commit_and_push",
                    },
                },
            },
            document_symbols = {
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
        },
        keys = {
            { "<leader>lf", "<cmd>Neotree source=filesystem reveal=true<cr>",  desc = "Locate File" },
            {
                "<leader>oe",
                "<cmd>Neotree source=filesystem reveal=false toggle=true<cr>",
                desc = "Open Explorer",
            },
            { "<leader>oo", "<cmd>Neotree position=right document_symbols reveal=true<cr>", desc = "Open Outline" },
            { "<leader>ls", "<cmd>Neotree position=right document_symbols reveal=true<cr>", desc = "Locate Symbol" },
        },
    },
    {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        lazy = true,
        name = "window-picker",
        opts = {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
                bo = {
                    -- if the file type is one of following, the window will be ignored
                    filetype = { "neo-tree", "neo-tree-popup", "notify", "neotest-summary", "NeogitStatus", "help",
                        "Outline" },
                    -- if the buffer type is one of following, the window will be ignored
                    buftype = { "terminal", "quickfix" },
                },
            },
        },
    },
}
