-- +---------------------------------------------------------+
-- | artemave/workspace-diagnostics.nvim: Workspace          |
-- | Diagnostics                                             |
-- +---------------------------------------------------------+

--+- Settings -----------------------------------------------+
local workspace_diagnostic_whitelist = { "tsserver", "pyright" }

--+- Enable Workspace Diagnostics ---------------------------+
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachDisableVirtualText", { clear = true }),
    desc = "Disable Virtual Diagnostic Hints",
    callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end

        if vim.tbl_contains(workspace_diagnostic_whitelist, client.name) then
            require("workspace-diagnostics").populate_workspace_diagnostics(client, buffer) -- stylua: ignore
        end
    end,
})