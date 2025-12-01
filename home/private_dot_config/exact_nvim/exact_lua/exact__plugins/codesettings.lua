-- +---------------------------------------------------------+
-- | mrjones2014/codesettings.nvim                           |
-- +---------------------------------------------------------+

local codesettings = require("codesettings")
codesettings.setup({})

vim.lsp.config("*", {
    before_init = function(_, config)
        config = codesettings.with_local_settings(config.name, config)
    end,
})
