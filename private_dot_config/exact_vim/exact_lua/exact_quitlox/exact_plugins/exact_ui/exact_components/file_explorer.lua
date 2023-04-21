local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default Mappings
  api.config.mappings.default_on_attach(bufnr)

    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    vim.keymap.set('n', 'v', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', 'b', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<M-l>', ':NvimTreeResize +2<CR>', opts('Resize: +2'))
    vim.keymap.set('n', '<M-h>', ':NvimTreeResize -2<CR>', opts('Resize: -2'))

end

return {
    "kyazdani42/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            on_attach = on_attach,
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
        require("quitlox.util.which_key").register({
            o = {
                -- t = { "<cmd>NvimTreeToggle<cr>", "Open Tree" },
                e = { "<cmd>NvimTreeToggle<cr>", "Open Explorer" },
            },
            T = {
                f = { "<cmd>NvimTreeToggle<cr>", "Toggle File explorer" },
                e = { "<cmd>NvimTreeToggle<cr>", "Toggle Explorer" },
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
        }, { prefix = "<leader>", nowait = true })
    end,
}
