-- +---------------------------------------------------------+
-- | mrjones2014/codesettings.nvim                           |
-- +---------------------------------------------------------+

local codesettings = require("codesettings")
codesettings.setup({})

vim.lsp.config("*", {
    before_init = function(_, config)
        -- Load global defaults from Neovim config dir first
        codesettings.loader():root_dir(vim.fn.stdpath("config")):with_local_settings(config.name, config)
        -- Load project-local settings second (overrides global)
        codesettings.loader():root_dir(config.root_dir):with_local_settings(config.name, config)
    end,
})
