-- +---------------------------------------------------------+
-- | neovim/nvim-lspconfig: Collection of LSP Configurations |
-- +---------------------------------------------------------+

vim.diagnostic.config({
    virtual_text = false,
})

--+- Inlay Hints --------------------------------------------+
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachInlayHints", { clear = true }),
    desc = "Attach LSP inlay hints",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        if (client.supports_method and client.supports_method("textDocument/inlayHint")) or (client.server_capabilities and client.server_capabilities.inlayHintProvider) then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

--+- Keybindings --------------------------------------------+
local function set_keybindings(bufnr)
    -- stylua: ignore start
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Prev Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Next Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[w", function() vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Prev Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]w", function() vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Next Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "gs", "<cmd> Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", { desc = "Workspace Symbols", buffer = bufnr, silent = true, noremap = true })
    -- stylua: ignore end

    vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr, silent = true, noremap = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachKeybinding", { clear = true }),
    desc = "Attach LSP keybindings",
    callback = function(args) set_keybindings(args.buf) end,
})

--+- LSP Commands -------------------------------------------+
require("legendary").commands({
    { ":LspInfo", description = "Show the status of active and configured language servers." },
    { ":LspStart", description = "Start the requested server name." },
    { ":LspStop", description = "Stop the requested server name." },
    { ":LspRestart", description = "Restart the requested server name." },
})

--+- LSP: Hyperlang -----------------------------------------+
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.hl", "hypr*.conf" },
    callback = function(event)
        vim.lsp.start({
            name = "hyprlang",
            cmd = { "hyprls" },
            root_dir = vim.fn.getcwd(),
        })
    end,
})

--+- LSP: Python --------------------------------------------+
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

--+- LSP: Other ---------------------------------------------+
require("lspconfig").cssls.setup({ capabilities = require("quitlox.util.lsp").capabilities })
require("lspconfig").bashls.setup({ capabilities = require("quitlox.util.lsp").capabilities })
