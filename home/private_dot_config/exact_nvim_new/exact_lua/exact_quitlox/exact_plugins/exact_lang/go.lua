-- +---------------------------------------------------------+
-- | ray-x/go.nvim: Go Support                               |
-- +---------------------------------------------------------+

-- Setup
require("go").setup({
    lsp_cfg = {
        capabilities = require("quitlox.util.lsp").capabilities,
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.bufnr
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name ~= "gopls" then return end

        -- Override the default annotation keymap
        vim.keymap.set("n", "<Leader>gca", require("go.comment").gen, { noremap = true, silent = true, desc = "Generate Annotation", buffer = bufnr })
    end,
})

-- Commands
require("legendary").commands({
    -- Autofill
    { ":GoFillStruct", description = "Auto fill struct", filters = { ft = { "go", "gomod" } } },
    { ":GoFillSwitch", description = "Auto fill switch", filters = { ft = { "go", "gomod" } } },
    { ":GoIfErr", description = "Add if err", filters = { ft = { "go", "gomod" } } },
    { ":GoFixPlurals", description = "Simply function parameter types", filters = { ft = { "go", "gomod" } } },
    -- Build and test
    { ":GoMake", description = "Async make", filters = { ft = { "go", "gomod" } } },
    { ":GoTest", description = "Go Test", filters = { ft = { "go", "gomod" } } },
    -- TODO: Incomplete
})

-- Install the required dependencies
vim.api.nvim_create_autocmd("FileType", { pattern = "go", callback = function() require("go.install").install() end })
