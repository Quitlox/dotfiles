-- +---------------------------------------------------------+
-- | neovim/nvim-lspconfig: Collection of LSP Configurations |
-- +---------------------------------------------------------+

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