----------------------------------------
-- General Server Settings (e.g. Keybindings)
----------------------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Cursor Highlight
    require("illuminate").on_attach(client)

    -- Default Mappings
    local set_keybindings = require("quitlox.plugins.lsp.include.keybindings")
    set_keybindings(bufnr)

    -- Enable autocompletion
    -- vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

    -- Disable default inline diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = false,
    })

    -- Breadcrumbs
    import("nvim-navic", function(navic)
        if client.server_capabilities.documentSymbolProvider then navic.attach(client, bufnr) end
    end)
end

-- Completion Capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Languages

-- svelte
-- tailwindcss
-- dockerls
-- bashls
-- texlab
-- vimls
-- pyright

return {
    capabilities = capabilities,
    on_attach = on_attach,
}
