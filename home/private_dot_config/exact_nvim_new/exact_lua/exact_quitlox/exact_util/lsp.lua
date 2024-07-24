local M = {}

local function make_capabilities()
    -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)
    return capabilities
end

M.capabilities = make_capabilities()

return M
