-- +---------------------------------------------------------+
-- | joshzcold/python.nvim: Python Support                   |
-- +---------------------------------------------------------+

require("python").setup(
    ---@type python.Config
    ---@diagnostic disable-line:missing-fields
    {
        -- TODO: Create issue, should automatically detect .venv
        get_venvs = function(venvs_path)
            local global = require("python.venv").get_venvs(venvs_path)
            local dir = vim.fn.getcwd() .. "/.venv"
            if vim.fn.isdirectory(dir) == 1 then
                table.insert(global, { name = ".venv", path = dir, source = "venv" })
            end

            return global
        end,

        auto_venv_lsp_attach_patterns = { "*.py" }, -- FIXME: for some reason, I cannot add pyproject.toml here without setup complaining
        command_setup_buf_pattern = { "*.py" },

        test = {
            test_runner = "pytest",
        },
    }
)

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<localleader>pv", "<cmd>Python venv pick<cr>", { desc = "python.nvim: pick venv" })
vim.keymap.set("n", "<localleader>pi", "<cmd>Python venv install<cr>", { desc = "python.nvim: python venv install" })
vim.keymap.set("n", "<localleader>pd", "<cmd>Python dap<cr>", { desc = "python.nvim: python run debug program" })

-- Test Actions
vim.keymap.set("n", "<localleader>ptt", "<cmd>Python test<cr>", { desc = "python.nvim: python run test suite" })
vim.keymap.set("n", "<localleader>ptm", "<cmd>Python test_method<cr>", { desc = "python.nvim: python run test method" })
vim.keymap.set("n", "<localleader>ptf", "<cmd>Python test_file<cr>", { desc = "python.nvim: python run test file" })
vim.keymap.set("n", "<localleader>ptdd", "<cmd>Python test_debug<cr>", { desc = "python.nvim: run test suite in debug mode." })
vim.keymap.set("n", "<localleader>ptdm", "<cmd>Python test_method_debug<cr>", { desc = "python.nvim: run test method in debug mode." })
vim.keymap.set("n", "<localleader>ptdf", "<cmd>Python test_file_debug<cr>", { desc = "python.nvim: run test file in debug mode." })

-- VEnv Actions
vim.keymap.set("n", "<localleader>ped", "<cmd>Python venv delete_select<cr>", { desc = "python.nvim: select and delete a known venv." })
vim.keymap.set("n", "<localleader>peD", "<cmd>Python venv delet<cr>", { desc = "python.nvim: delete current venv set." })

-- Language Actions
vim.keymap.set("n", "<localleader>ppe", "<cmd>Python treesitter toggle_enumerate<cr>", { desc = "python.nvim: turn list into enumerate" })
vim.keymap.set("n", "<localleader>pw", "<cmd>Python treesitter wrap_cursor<cr>", { desc = "python.nvim: wrap treesitter identifier with pattern" })

require("which-key").add({
    { "<localleader>p", group = "Python" },
    { "<localleader>pe", group = "Python Env" },
    { "<localleader>pp", group = "Python Lang" },
    { "<localleader>pt", group = "Python Test" },
})
