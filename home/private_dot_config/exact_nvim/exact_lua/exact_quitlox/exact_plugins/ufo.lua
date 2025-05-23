-- +---------------------------------------------------------+
-- | kevinhwang91/nvim-ufo: Modernize folding                |
-- +---------------------------------------------------------+

-- Options
vim.opt.foldcolumn = "1"
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

--+- Integration: Set LSP capabilities ----------------------+
require("quitlox.util.lazy").on_module("lspconfig", function()
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    -- Set default server configuration
    require("lspconfig").util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig.util.default_config.capabilities),
    })

    -- Set capabilities for each initialized server
    for server, config in pairs(configs) do
        vim.tbl_deep_extend("force", config or {}, {
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            },
        })
        lspconfig[server].setup(config)
    end
end)

--+- Setup --------------------------------------------------+
local filetype_map = {
    vim = "indent",
    lua = "lsp",
}
require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
        return filetype_map[filetype]
    end,
})
