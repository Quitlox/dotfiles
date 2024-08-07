-- +---------------------------------------------------------+
-- | nvim-telescope/telescope.nvim: Finder                   |
-- +---------------------------------------------------------+

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then vim.g.sqlite_clib_path = vim.fn.expand("$HOME/.config/vim/sqlite3.dll") end

require("telescope").setup({
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
                ["<C-t>"] = require("trouble.sources.telescope").open,
            },
            n = {
                ["<C-t>"] = require("trouble.sources.telescope").open,
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
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>fa", function() require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({ layout_config = { width = 0.6 } })) end, { noremap = true, silent = true, desc = "Find All" })
vim.keymap.set("n", "<leader>fm", function() require("telescope.builtin").man_pages(require("telescope.themes").get_dropdown({})) end, { noremap = true, silent = true, desc = "Find Manpage" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").resume(require("telescope.themes").get_ivy({})) end, { noremap = true, silent = true, desc = "Find Resume" })
vim.keymap.set("n", "<leader>gb", function() require("telescope.builtin").git_branches(require("telescope.themes").get_ivy({})) end, { noremap = true, silent = true, desc = "Git Branches" })
require("which-key").add({ { "<leader>f", group = "Find" } })
-- stylua: ignore end

--+- Workaround ---------------------------------------------+
-- Telescope opens file in insert mode after neovim commit: d52cc66
-- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1541009573
-- Neovim commit pull request: https://github.com/neovim/neovim/pull/22984
-- Workaround: Leave insert mode when leaving Telescope prompt.
-- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730
local telescope_augroup_id = vim.api.nvim_create_augroup("telescope_settings", {})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = telescope_augroup_id,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "TelescopePrompt" and vim.fn.mode() == "i" then vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false) end
    end,
})

-- +---------------------------------------------------------+
-- | nvim-telescope/telescope-fzf-native.nvim                |
-- +---------------------------------------------------------+

-- if vim.fn.has("win64") == 0 then require("telescope").load_extension("fzf") end
require("telescope").load_extension("fzf")

-- +---------------------------------------------------------+
-- | danielfalk/smart-open.nvim                              |
-- +---------------------------------------------------------+

-- stylua: ignore start
require("telescope").load_extension("smart_open")
vim.keymap.set("n", "<leader>of", function() require("telescope").extensions.smart_open.smart_open(require("telescope.themes").get_dropdown({})) end, {noremap = true, silent = true, desc = "Open File"})
vim.keymap.set("n", "<leader>oa", "<cmd>Telescope find_files cwd=~<cr>", { noremap = true, silent = true, desc = "Open Any File" })
-- stylua: ignore end

-- +---------------------------------------------------------+
-- | catgoose/telescope-helpgrep.nvim                        |
-- +---------------------------------------------------------+

require("telescope").load_extension("helpgrep")
vim.keymap.set("n", "<leader>fh", function() require("telescope-helpgrep").live_grep(require("telescope.themes").get_dropdown({})) end, { noremap = true, silent = true, desc = "Find Help" })
