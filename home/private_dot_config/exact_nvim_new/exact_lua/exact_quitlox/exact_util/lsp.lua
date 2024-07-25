local M = {}

local function make_capabilities()
    -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38

    local success, mod = pcall(require, "cmp_nvim_lsp")
    if not success then
        vim.notify("cmp_nvim_lsp not installed", vim.log.levels.ERROR, { title = "Error" })
        return vim.lsp.protocol.make_client_capabilities()
    end

    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = mod.default_capabilities()
    local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)
    return capabilities
end

M.capabilities = make_capabilities()

return M
