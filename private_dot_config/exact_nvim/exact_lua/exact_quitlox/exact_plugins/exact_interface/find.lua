----------------------------------------
-- Setup
----------------------------------------

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.g.sqlite_clib_path = vim.fn.expand("$HOME/.config/vim/sqlite3.dll")
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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

            require("telescope").load_extension("fzf")
        end,

        init = function()
            require("which-key").register({
                f = {
                    name = "Find",
                    a = { "<cmd>Telescope live_grep theme=dropdown<cr>", "Find All" },
                    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
                    d = { "<cmd>Telescope diagnostics<cr>", "Find Diagnostics" },
                    -- t = { "<cmd>Telescope tags<cr>", "Find Tags" },
                    n = { "<cmd>TodoTelescope<cr>", "Find Notes" },
                    m = { "<cmd>Telescope man_pages theme=dropdown <cr>", "Find Manpage" },
                    h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "Find Help" },
                },
                o = {
                    name = "Open",
                    f = { "<cmd>Telescope smart_open cwd_only=true theme=dropdown<cr>", "Open File" },
                    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
                },
            }, { prefix = "<leader>" })

            require("which-key").register({
                [";"] = {
                    "<cmd>lua require('telescope.builtin').resume(require('telescope.themes').get_ivy({}))<cr>",
                    "Resume Telescope",
                },
            })

            -- NOTE: Telescope opens file in insert mode after neovim commit: d52cc66
            -- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1541009573
            -- Neovim commit pull request: https://github.com/neovim/neovim/pull/22984
            -- Workaround: Leave insert mode when leaving Telescope prompt.
            -- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730
            local telescope_augroup_id = vim.api.nvim_create_augroup("telescope_settings", {})
            vim.api.nvim_create_autocmd({ "WinLeave" }, {
                group = telescope_augroup_id,
                pattern = "*",
                callback = function()
                    if vim.bo.filetype == "TelescopePrompt" and vim.fn.mode() == "i" then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
                    end
                end,
            })
        end,
    },
    {
        "danielfalk/smart-open.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope.nvim",
        },
        config = function() require("telescope").load_extension("smart_open") end,
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function() require("telescope").load_extension("undo") end,
    },
}
