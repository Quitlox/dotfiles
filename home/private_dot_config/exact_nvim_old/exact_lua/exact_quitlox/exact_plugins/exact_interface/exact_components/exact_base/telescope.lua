----------------------------------------
-- Setup
----------------------------------------

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.g.sqlite_clib_path = vim.fn.expand("$HOME/.config/vim/sqlite3.dll")
end

return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            default = {
                { "<leader>f", group = "Find" },
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        version = "",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                enabled = function() return vim.fn.has("win64") == 0 end,
                build = "make",
                config = function() require("telescope").load_extension("fzf") end,
            },
        },
        opts = function(_, opts)
            return {
                defaults = {
                    path_display = { "smart", "truncate" },
                    mappings = {
                        i = {
                            ["<ESC>"] = require("telescope.actions").close,
                            ["<C-BS>"] = { "<C-S-w>", type = "command" },
                            ["<C-H>"] = { "<C-S-w>", type = "command" },
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-v>"] = require("telescope.actions").select_horizontal,
                            ["<C-b>"] = require("telescope.actions").select_vertical,
                        },
                    },
                    preview = {
                        filesize_hook = function(filepath, bufnr, opts)
                            local max_bytes = 10000
                            local cmd = { "head", "-c", max_bytes, filepath }
                            require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
                        end,
                    },
                },
                extensions = {
                    smart_open = {
                        cwd_only = true,
                        match_algorithm = "fzf",
                        ignore_patterns = { "*.git/*", "*/tmp/*", ".venv/*" },
                    },
                },
            }
        end,
        keys = {
            -- TODO: Hopefully the following get resolves, to set a default theme
            -- https://github.com/nvim-telescope/telescope.nvim/issues/848
            {
                "<leader>fa",
                function()
                    require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({
                        layout_config = { width = 0.6 },
                    }))
                end,
                desc = "Find All",
            },
            {
                "<leader>fm",
                function() require("telescope.builtin").man_pages(require("telescope.themes").get_dropdown({})) end,
                desc = "Find Manpage",
            },
            {
                "<leader>fr",
                function() require("telescope.builtin").resume(require("telescope.themes").get_ivy({})) end,
                desc = "Find Resume",
            },
        },
        cmd = { "Telescope" },
        init = function()
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
        branch = "0.2.x",
        dependencies = {
            "kkharji/sqlite.lua",
        },
        config = function() require("telescope").load_extension("smart_open") end,
        keys = {
            {
                "<leader>of",
                function() require("telescope").extensions.smart_open.smart_open(require("telescope.themes").get_dropdown({})) end,
                desc = "Open File",
            },
            {
                "<leader>oa",
                "<cmd>Telescope find_files cwd=~<cr>",
                desc = "Open Any File",
            },
        },
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function() require("telescope").load_extension("undo") end,
        keys = { {
            "<leader>fu",
            function() require("telescope").extensions.undo.undo() end,
            desc = "Undo History",
        } },
    },
    {
        "catgoose/telescope-helpgrep.nvim",
        config = function() require("telescope").load_extension("helpgrep") end,
        keys = {
            {
                "<leader>fh",
                function() require("telescope-helpgrep").live_grep() end,
                desc = "Find Help",
            },
        },
    },
}
