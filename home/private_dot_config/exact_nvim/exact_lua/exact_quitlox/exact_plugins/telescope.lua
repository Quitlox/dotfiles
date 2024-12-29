-- +---------------------------------------------------------+
-- | nvim-telescope/telescope.nvim: Finder                   |
-- +---------------------------------------------------------+

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.g.sqlite_clib_path = vim.fn.expand("$HOME/.config/vim/sqlite3.dll")
end

local actions = require("telescope.actions")

local git_switch_branch = function(prompt_bufnr)
    actions.git_switch_branch(prompt_bufnr)

    vim.schedule(function()
        -- Integration: reset gitsigns base
        local success, gitsigns = pcall(require, "gitsigns")
        if success then
            gitsigns.reset_base()
        end
    end)
end

require("telescope").setup({
    defaults = {
        path_display = { "smart", "truncate" },
        mappings = {
            i = {
                ["<ESC>"] = actions.close,
                ["<C-BS>"] = { "<C-S-w>", type = "command" },
                ["<C-H>"] = { "<C-S-w>", type = "command" },
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-v>"] = actions.select_horizontal,
                ["<C-b>"] = actions.select_vertical,
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
    pickers = {
        git_branches = {
            mappings = {
                -- Overwrite default
                -- Make sure that switching to remote branch actually checks it out as a new local branch
                i = { ["<cr>"] = git_switch_branch },
            },
        },
    },
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>fa", function() require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({ layout_config = { width = 0.6 } })) end, { noremap = true, silent = true, desc = "Find All" })
vim.keymap.set("n", "<leader>fm", function() require("telescope.builtin").man_pages(require("telescope.themes").get_dropdown({})) end, { noremap = true, silent = true, desc = "Find Manpage" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").resume(require("telescope.themes").get_ivy({})) end, { noremap = true, silent = true, desc = "Find Resume" })
vim.keymap.set("n", "<leader>gb", function() require("telescope.builtin").git_branches(require("telescope.themes").get_ivy({})) end, { noremap = true, silent = true, desc = "Git Branches" })
-- stylua: ignore end

--+- Workaround ---------------------------------------------+
-- Telescope opens file in insert mode after neovim commit: d52cc66
-- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1541009573
-- Neovim commit pull request: https://github.com/neovim/neovim/pull/22984
-- Workaround: Leave insert mode when leaving Telescope prompt.
-- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730
local telescope_augroup_id = vim.api.nvim_create_augroup("telescope_settings", { clear = true })
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = telescope_augroup_id,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        end
    end,
})
