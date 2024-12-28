-- +---------------------------------------------------------+
-- | kevinhwang91/nvim-ufo: Modernize folding                |
-- +---------------------------------------------------------+

local function setup()
    -- Options
    vim.opt.foldcolumn = "0"
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    -- Keymaps
    vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Fold less" })
    vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Fold more" })
    vim.keymap.set("n", "[z", function() require("ufo").goPreviousClosedFold() end, { desc = "Next fold" })
    vim.keymap.set("n", "]z", function() require("ufo").goNextClosedFold() end, { desc = "Next fold" })

    -- Commands
    require("legendary").commands({
        { ":UfoEnable", description = "Enable ufo" },
        { ":UfoDisable", description = "Disable ufo" },
        { ":UfoInspect", description = "Inspect current buffer information" },
        { ":UfoAttach", description = "Attach current buffer to enable all features" },
        { ":UfoDetach", description = "Detach current buffer to disable all features" },
        { ":UfoEnableFold", description = "Enable to get folds and update them at once for current buffer" },
        { ":UfoDisableFold", description = "Disable to get folds for current buffer" },
    })

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

    -- Setup
    local opts = {
        provider_selector = function() return { "treesitter", "indent" } end,
    }
    require("ufo").setup(opts)
end

-- FIXME: Remove ufo if this is sufficient

-- FIXME:: Slows down legendary
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.fillchars = vim.opt.fillchars + "fold: "
