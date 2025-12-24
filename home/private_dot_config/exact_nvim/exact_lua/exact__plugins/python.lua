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
        python_lua_snippets = false,

        keymaps = {
            -- TODO: Issue: using custom mappings is not actually supported here "unknown value"
            -- Submit issue to plugin author, note that this is an anti-pattern anyway.
            mappings = {},
        },

        test = {
            test_runner = "pytest",
        },
    }
)

vim.keymap.set("n", "<localleader>pv", "<cmd>Python venv pick<cr>", { desc = "python.nvim: pick venv" })
vim.keymap.set("n", "<localleader>pi", "<cmd>Python venv install<cr>", { desc = "python.nvim: python venv install" })
-- VEnv Actions
vim.keymap.set("n", "<localleader>pd", "<cmd>Python venv delete_select<cr>", { desc = "python.nvim: select and delete a known venv." })
vim.keymap.set("n", "<localleader>pD", "<cmd>Python venv delete<cr>", { desc = "python.nvim: delete current venv set." })
-- Language Actions
vim.keymap.set("n", "<localleader>pe", "<cmd>Python treesitter toggle_enumerate<cr>", { desc = "python.nvim: turn list into enumerate" })

require("which-key").add({
    { "<localleader>p", group = "Python" },
})
