----------------------------------------
-- Setup
----------------------------------------

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.g.sqlite_clib_path = vim.fn.expand("$HOME/.config/vim/sqlite3.dll")
end

-- TODO: Make FZF ignore ignored files
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        cmd = "Telescope",
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = { "smart", "truncate" },
                    mappings = {
                        i = {
                            ["<ESC>"] = require("telescope.actions").close,
                            ["<C-BS>"] = require("telescope.actions").close,
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-v>"] = require("telescope.actions").select_horizontal,
                            ["<C-b>"] = require("telescope.actions").select_vertical,
                        },
                    },
                },
                extensions = {
                    smart_open = {
                        cwd_only = true,
                    },
                },
            })
        end,

        init = function()
            require("which-key").register({
                f = {
                    name = "Find",
                    a = { "<cmd>Telescope live_grep theme=dropdown<cr>", "Find All" },
                    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
                    r = { "<cmd>Telescope lsp_references<cr>", "Find References" },
                    d = { "<cmd>Telescope diagnostics<cr>", "Find Diagnostics" },
                    i = { "<cmd>Telescope lsp_implementations<cr>", "Find Implementations" },
                    y = { "<cmd>Telescope lsp_type_definitions<cr>", "Find type definitions" },
                    t = { "<cmd>Telescope tags<cr>", "Find Tags" },
                    n = { "<cmd>TodoTelescope<cr>", "Find Notes" },
                    m = { "<cmd>Telescope man_pages theme=dropdown <cr>", "Find Manpage" },
                    h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "Find Help" },
                    s = { "<cmd>Telescope dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Find Symbols" },
                },
                o = {
                    name = "Open",
                    f = { "<cmd>Telescope smart_open cwd_only=true theme=dropdown<cr>", "Open File" },
                    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
                },
            }, { prefix = "<leader>" })
        end,
    },
    {
        "danielfalk/smart-open.nvim",
        -- TODO: This does not work??
        -- keys = { "<space>of" },
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope.nvim",
        },
        config = function() require("telescope").load_extension("smart_open") end,
    },
}
