-- +---------------------------------------------------------+
-- | mrjones2014/codesettings.nvim                           |
-- +---------------------------------------------------------+

local codesettings = require("codesettings")
codesettings.setup({
    -- Provide a non-nil fallback root so the vscode variable extension doesn't
    -- crash on rootless scratch buffers (e.g. conform's `injected` formatter
    -- loading a YAML block out of a markdown file). See vscode.lua:37, which
    -- calls Util.get_root() ignoring the loader's root_dir and indexes a nil
    -- root. Our before_init below passes an explicit root_dir for the actual
    -- config lookup, so this fallback only affects variable resolution.
    root_dir = function()
        return vim.fs.root(0, { ".git", ".jj", ".vscode", "codesettings.json", "lspsettings.json" })
            or vim.fn.stdpath("config")
    end,
})

vim.lsp.config("*", {
    before_init = function(_, config)
        -- Load global defaults from Neovim config dir first
        codesettings.loader():root_dir(vim.fn.stdpath("config")):with_local_settings(config.name, config)
        -- Load project-local settings second (overrides global)
        if config.root_dir then
            codesettings.loader():root_dir(config.root_dir):with_local_settings(config.name, config)
        end
    end,
})
