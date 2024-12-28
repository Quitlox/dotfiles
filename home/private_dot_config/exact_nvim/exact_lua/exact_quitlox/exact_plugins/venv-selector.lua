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
require("legendary").commands({
    { ":VenvSelect", description = "Select Virtual Env" },
    { ":VenvDeactivate", require("quitlox.util.python").deactivate, description = "Deactivate Virtual Env" },
    { ":VenvCreate", require("quitlox.util.python").create_venv_in_cwd, description = "Create Virtual Env" },
})

-- On startup, check whether VIRTUAL_ENV is set and activate it.
-- if os.getenv("VIRTUAL_ENV") then
--     require("quitlox.util.python").activate_venv(os.getenv("VIRTUAL_ENV"), nil, nil)
-- end
