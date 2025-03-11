-- +---------------------------------------------------------+
-- | linux-cultist/venv-selector.nvim: Virtual Environment   |
-- +---------------------------------------------------------+

require("venv-selector").setup({
    require_lsp_activation = false,
    settings = {
        search = { hatch = false, pyenv = false, pipenv = false, anaconda_envs = false, anaconda_base = false, miniconda_envs = false, file = false, pipx = false },
        cache = {
            file = vim.fn.stdpath("data") .. "/nvim/venv-selector/cache.json",
        },
        options = {
            enable_cached_venvs = false,
            activate_venv_in_terminal = true,
            notify_user_on_venv_activation = false,
            require_lsp_activation = false,
            debug = true,
        },
    },
})

--+- Commands -----------------------------------------------+
vim.api.nvim_create_user_command("VenvSelect", function()
    require("venv-selector").select_venv()
end, { desc = "Select Virtual Env" })
vim.api.nvim_create_user_command("VenvDeactivate", function()
    require("quitlox.util.python").deactivate()
end, { desc = "Deactivate Virtual Env" })
vim.api.nvim_create_user_command("VenvCreate", function()
    require("quitlox.util.python").create_venv_in_cwd()
end, { desc = "Create Virtual Env" })
