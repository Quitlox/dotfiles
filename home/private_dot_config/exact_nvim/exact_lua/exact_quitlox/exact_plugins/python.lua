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

        post_set_venv = nil,
        auto_venv_lsp_attach_patterns = { "*.py", "pyproject.toml" },
        command_setup_filetypes = { "python", "toml.python" },
        python_lua_snippets = false,

        enabled_text_actions = {
            "f-strings",
        },
        enabled_text_actions_autocmd_events = { "InsertLeave" },

        keymaps = {},

        test = {
            test_runner = "pytest",
        },
    }
)

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<localleader>pv", "<cmd>PythonVEnvPick<cr>", { desc = "python.nvim: pick venv" })
vim.keymap.set("n", "<localleader>pi", "<cmd>PythonVEnvInstall<cr>", { desc = "python.nvim: python venv install" })
vim.keymap.set("n", "<localleader>pd", "<cmd>PythonDap<cr>", { desc = "python.nvim: python run debug program" })

-- Test Actions
vim.keymap.set("n", "<localleader>ptt", "<cmd>PythonTest<cr>", { desc = "python.nvim: python run test suite" })
vim.keymap.set("n", "<localleader>ptm", "<cmd>PythonTestMethod<cr>", { desc = "python.nvim: python run test method" })
vim.keymap.set("n", "<localleader>ptf", "<cmd>PythonTestFile<cr>", { desc = "python.nvim: python run test file" })
vim.keymap.set("n", "<localleader>ptdd", "<cmd>PythonDebugTest<cr>", { desc = "python.nvim: run test suite in debug mode." })
vim.keymap.set("n", "<localleader>ptdm", "<cmd>PythonDebugTestMethod<cr>", { desc = "python.nvim: run test method in debug mode." })
vim.keymap.set("n", "<localleader>ptdf", "<cmd>PythonDebugTestFile<cr>", { desc = "python.nvim: run test file in debug mode." })

-- VEnv Actions
vim.keymap.set("n", "<localleader>ped", "<cmd>PythonVEnvDeleteSelect<cr>", { desc = "python.nvim: select and delete a known venv." })
vim.keymap.set("n", "<localleader>peD", "<cmd>PythonVEnvDelete<cr>", { desc = "python.nvim: delete current venv set." })

-- Language Actions
vim.keymap.set("n", "<localleader>ppe", "<cmd>PythonTSToggleEnumerate<cr>", { desc = "python.nvim: turn list into enumerate" })

require("which-key").add({
    { "<localleader>p", group = "Python" },
    { "<localleader>pe", group = "Python Env" },
    { "<localleader>pp", group = "Python Lang" },
    { "<localleader>pt", group = "Python Test" },
})
