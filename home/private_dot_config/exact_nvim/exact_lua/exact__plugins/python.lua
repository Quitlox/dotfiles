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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("MyPythonKeybindings", { clear = true }),
    callback = function(event)
        --+- Keymaps ------------------------------------------------+
        vim.keymap.set("n", "<localleader>v", "<cmd>Python venv pick<cr>", { desc = "python.nvim: pick venv", buffer = event.buf })
        vim.keymap.set("n", "<localleader>i", "<cmd>Python venv install<cr>", { desc = "python.nvim: python venv install", buffer = event.buf })
        vim.keymap.set("n", "<localleader>d", "<cmd>Python dap<cr>", { desc = "python.nvim: python run debug program", buffer = event.buf })

        -- Test Actions
        vim.keymap.set("n", "<localleader>tt", "<cmd>Python test<cr>", { desc = "python.nvim: python run test suite", buffer = event.buf })
        vim.keymap.set("n", "<localleader>tm", "<cmd>Python test_method<cr>", { desc = "python.nvim: python run test method", buffer = event.buf })
        vim.keymap.set("n", "<localleader>tf", "<cmd>Python test_file<cr>", { desc = "python.nvim: python run test file", buffer = event.buf })
        vim.keymap.set("n", "<localleader>tdd", "<cmd>Python test_debug<cr>", { desc = "python.nvim: run test suite in debug mode.", buffer = event.buf })
        vim.keymap.set("n", "<localleader>tdm", "<cmd>Python test_method_debug<cr>", { desc = "python.nvim: run test method in debug mode.", buffer = event.buf })
        vim.keymap.set("n", "<localleader>tdf", "<cmd>Python test_file_debug<cr>", { desc = "python.nvim: run test file in debug mode.", buffer = event.buf })

        -- VEnv Actions
        vim.keymap.set("n", "<localleader>ed", "<cmd>Python venv delete_select<cr>", { desc = "python.nvim: select and delete a known venv.", buffer = event.buf })
        vim.keymap.set("n", "<localleader>eD", "<cmd>Python venv delet<cr>", { desc = "python.nvim: delete current venv set.", buffer = event.buf })

        -- Language Actions
        vim.keymap.set("n", "<localleader>pe", "<cmd>Python treesitter toggle_enumerate<cr>", { desc = "python.nvim: turn list into enumerate", buffer = event.buf })
        vim.keymap.set("n", "<localleader>w", "<cmd>Python treesitter wrap_cursor<cr>", { desc = "python.nvim: wrap treesitter identifier with pattern", buffer = event.buf })

        require("which-key").add({
            { "<localleader>", group = "Python", buffer = event.buf },
            { "<localleader>e", group = "Python Env", buffer = event.buf },
            { "<localleader>p", group = "Python Lang", buffer = event.buf },
            { "<localleader>t", group = "Python Test", buffer = event.buf },
        })
    end,
})
