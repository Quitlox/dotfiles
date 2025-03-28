-- +---------------------------------------------------------+
-- | kevinhwang91/nvim-ufo: Modernize folding                |
-- +---------------------------------------------------------+

-- Options
-- vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Keymaps
-- stylua: ignore start
vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Fold less" })
vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Fold more" })
vim.keymap.set("n", "[z", function() require("ufo").goPreviousClosedFold() end, { desc = "Next fold" })
vim.keymap.set("n", "]z", function() require("ufo").goNextClosedFold() end, { desc = "Next fold" })
-- stylua: ignore end

-- Hover
require("hover").register({
    priority = 1002,
    name = "Fold",
    enabled = function(bufnr)
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        return winid ~= nil
    end,
    execute = function(opts, done) end,
})

--+- Integration: set LSP capabilities ----------------------+
require("quitlox.util.lazy").on_module("lspconfig", function()
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    local new_capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    }

    -- Set default server configuration
    require("lspconfig").util.default_config = vim.tbl_extend("force", lspconfig.util.default_config.capabilities, new_capabilities)

    -- Update capabilities for each initialized server
    for server, config in pairs(configs) do
        config.capabilities = vim.tbl_extend("force", config.capabilities, new_capabilities)
        lspconfig[server].setup(config)
    end
end)

-- Setup
require("ufo").setup({
    provider_selector = function()
        return { "treesitter", "indent" }
    end,
})

-- FIXME: Remove ufo if this is sufficient

-- Alternative no ufo configuration
-- -- FIXME:: Slows down legendary
-- vim.opt.foldlevel = 99
-- vim.opt.foldenable = true
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
-- -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = ""
-- vim.opt.fillchars = vim.opt.fillchars + "fold: "
