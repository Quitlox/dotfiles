-- +---------------------------------------------------------+
-- | jmbuhr/otter.nvim                                       |
-- +---------------------------------------------------------+

require("otter").setup()

vim.api.nvim_create_autocmd("FileType", {
    pattern = "svelte",
    group = vim.api.nvim_create_augroup("MyOtterActiviationTypescript", { clear = true }),
    desc = "Activate Otter.nvim for Svelte",
    callback = function()
        require("otter").activate()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = vim.api.nvim_create_augroup("MyOtterActiviationObsidian", { clear = true }),
    desc = "Activate Otter.nvim for Obsidian",
    callback = function()
        -- check if buffer is in obsidian vault
        if vim.fn.expand("%:p"):match("^" .. vim.fn.expand("$HOME") .. "/Obsidian") then
            vim.notify("Activating otter-lsp for Obsidian", vim.log.levels.INFO, { title = "Otter.nvim" })
            require("otter").activate({ "texlab" })
        end
    end,
})

--+- Integration: Resession ---------------------------------+
-- Detach otter-lsp from all buffers when swiching to a new session
local _, success = pcall(require, "resession")
if success then
    require("resession").add_hook("pre_load", function()
        -- Loop through all buffers
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            -- Find client_id of otter-lsp
            local client_id = nil
            for _, client in ipairs(vim.lsp.get_clients()) do
                if client.name == "otter-ls" then
                    client_id = client.id
                    break
                end
            end

            -- Check if otter-lsp is attached to the buffer
            if vim.lsp.buf_is_attached(bufnr, client_id) then
                -- vim.notify("Detaching otter-lsp from buffer " .. bufnr, vim.log.levels.INFO, { title = "Otter.nvim" })
                vim.api.nvim_set_current_buf(bufnr)
                require("otter").deactivate()
            end
        end
    end)
end
