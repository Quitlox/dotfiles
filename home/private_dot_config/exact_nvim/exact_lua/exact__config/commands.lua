-- :W saves file using sudo
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <bar> edit!", { bang = true })

--+- Helper Functions ---------------------------------------+
local function resetBuffer()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    if filetype == "" then
        vim.notify("Buffer has no filetype set", vim.log.levels.WARN)
        return
    end

    -- Clear diagnostics
    vim.diagnostic.reset()

    -- Reset syntax highlighting
    vim.cmd("syntax sync fromstart")

    -- Stop existing LSP clients for this buffer
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end

    -- Trigger FileType autocommand to restart LSP (including semantic highlighting)
    vim.cmd("doautocmd FileType " .. filetype)

    vim.notify("Reset LSP, diagnostics, and highlighting for `" .. filetype .. "`", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("LspAttach", resetBuffer, {
    desc = "Reset LSP, diagnostics, and highlighting",
})

vim.keymap.set("n", "gA", resetBuffer, { desc = "Reset LSP, diagnostics, and highlighting" })

local function copyMessages()
    vim.cmd([[let @+ = execute('messages')]])
end

vim.api.nvim_create_user_command("CopyMessages", copyMessages, { desc = "Copy Messages to clipboard" })

--+- Utility Commands ---------------------------------------+
-- stylua: ignore
-- vim.api.nvim_create_user_command("DeleteDapLog", function() deleteFile(vim.fn.stdpath("cache") .. "/" .."dap.log") end, { desc = "Delete DAP Log" })
