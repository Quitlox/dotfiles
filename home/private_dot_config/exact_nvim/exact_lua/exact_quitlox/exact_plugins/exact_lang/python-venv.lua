-- +---------------------------------------------------------+
-- | linux-cultist/venv-selector.nvim: Virtual Environment   |
-- +---------------------------------------------------------+

require("venv-selector").setup({
    require_lsp_activation = false,
    settings = {
        search = { hatch = false, pyenv = false, pipenv = false, anaconda_envs = false, anaconda_base = false, miniconda_envs = false, file = false, pipx = false },
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
require("legendary").commands({
    { ":VenvSelect", description = "Select Virtual Env", filters = { ft = { "python" } } },
    { ":VenvDeactivate", require("quitlox.util.python").deactivate, description = "Deactivate Virtual Env", filters = { ft = { "python" } } },
    { ":VenvCreate", require("quitlox.util.python").create_venv_in_cwd, description = "Create Virtual Env" },
})
