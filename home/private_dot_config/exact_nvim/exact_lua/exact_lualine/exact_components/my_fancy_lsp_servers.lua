local M = require("lualine.component"):extend()

function M:init(options)
    options.icon = options.icon or " "
    options.split = options.split or " "
    options.separator = { right = "" }
    M.super.init(self, options)
end

function M:update_status()
    local buf_clients = nil
    if vim.lsp.get_clients ~= nil then
        -- buf_get_client is deprecated in nvim >=0.10.0
        buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    else
        buf_clients = vim.lsp.buf_get_clients()
    end

    local null_ls_installed, null_ls = pcall(require, "null-ls")
    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        if client.name ~= "GitHub Copilot" then table.insert(buf_client_names, client.name) end
    end
    return table.concat(buf_client_names, self.options.split)
end

return M
