--+- LSP ----------------------------------------------------+
---@diagnostic disable-next-line: missing-fields
require("lspconfig").pyright.setup({
    on_attach = function(client, bufnr)
        local function filter_diagnostics(diagnostic)
            if diagnostic.source ~= "Pyright" then return true end

            -- Just disable 'is not accessed' altogether
            if string.match(diagnostic.message, '".+" is not accessed') then return false end
            return true
        end

        local function custom_on_publish_diagnostics(a, params, client_id, c, config)
            require("quitlox.util.misc").filter(params.diagnostics, filter_diagnostics)
            vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
        end

        client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
    end,
    capabilities = require("quitlox.util.lsp").capabilities,
})

-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap-python: Python Debug Adapter      |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "python",
    once = true,
    callback = function()
        local pythondap = require("dap-python")

        -- Use available python interpreter (either venv or system python)
        pythondap.setup("python")
        -- Set pytest as default test runner
        pythondap.rest_runner = "pytest"
    end,
})
