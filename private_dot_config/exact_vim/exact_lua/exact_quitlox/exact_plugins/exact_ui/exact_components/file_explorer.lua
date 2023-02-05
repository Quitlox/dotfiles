return {
    "kyazdani42/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,

            tab = {
                sync = {
                    open = true,
                },
            },

            update_focused_file = {
                enable = true,
            },

            diagnostics = {
                enable = true,
                icons = {
                    hint = " ",
                    info = " ",
                },
            },

            view = {
                mappings = {
                    list = {
                        { key = "v", action = "split" },
                        { key = "b", action = "vsplit" },
                    },
                },
            },

            renderer = {
                group_empty = true,
                icons = { webdev_colors = true, git_placement = "after" },
                indent_markers = {
                    enable = false,
                },
                highlight_opened_files = "all",
            },

            filters = {
                custom = { "*.lock" },
            },

            live_filter = {
                prefix = " ",
                always_show_folders = false,
            },
        })

        -- Startup behavior
        local function open_nvim_tree()
            require('nvim-tree.api').tree.open()
        end

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end,
    init = function()
        require("which-key").register({
            T = {
                f = { "<cmd>NvimTreeToggle<cr>", "Toggle File explorer" },
            },
            f = {
                name = "Find",
                l = {
                    function()
                        local api = require("nvim-tree.api")
                        api.tree.find_file(vim.api.nvim_buf_get_name(0))
                        -- Guarantee that if file not found, the tree still opens
                        api.tree.open()
                    end,
                    "Find Location",
                },
            },
        }, { prefix = "<leader>" })
    end,
}
