-- +---------------------------------------------------------+
-- | neovim/nvim-lspconfig: Collection of LSP Configurations |
-- +---------------------------------------------------------+

--+- Integration: Neoconf -----------------------------------+
local neoconf, success = pcall(require, "neoconf")
if not success then
    vim.notify("Failed to `require('neoconf')`!", vim.log.levels.WARN)
else
    require("neoconf").setup({})
end

--+- Config: Inlay Hints ------------------------------------+
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachInlayHints", { clear = true }),
    desc = "Attach LSP inlay hints",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        if (client.supports_method and client.supports_method("textDocument/inlayHint")) or (client.server_capabilities and client.server_capabilities.inlayHintProvider) then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

--+- Keybindings --------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = { min = vim.diagnostic.severity.ERROR } }) end, { desc = "Prev Diagnostic", silent = true, noremap = true })
vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = { min = vim.diagnostic.severity.ERROR } }) end, { desc = "Next Diagnostic", silent = true, noremap = true })
vim.keymap.set("n", "[w", function() vim.diagnostic.jump({ count = -1, float = true, severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Prev Diagnostic", silent = true, noremap = true })
vim.keymap.set("n", "]w", function() vim.diagnostic.jump({ count = 1, float = true, severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Next Diagnostic", silent = true, noremap = true })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true, severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Prev Diagnostic", silent = true, noremap = true })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true, severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Next Diagnostic", silent = true, noremap = true })
-- vim.keymap.set("n", "[D", function() vim.diagnostic.jump({ count = -1, float = true, severity = { min = vim.diagnostic.severity.HINT }}) end, { desc = "Prev Error", silent = true, noremap = true })
-- vim.keymap.set("n", "]D", function() vim.diagnostic.jump({ count = 1, float = true, severity = { min = vim.diagnostic.severity.HINT }}) end, { desc = "Prev Error", silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code Action", silent = true, noremap = true }) -- Do not use LSPAttach, will be overwritten by default (vim ascii)
-- stylua: ignore end

--+- LSP: Toggle LSPs ---------------------------------------+
Snacks.toggle
    .new({
        name = "LSP",
        set = function()
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if vim.lsp.buf_is_attached(0, client.id) then
                    vim.lsp.buf_detach_client(0, client.id)
                else
                    vim.lsp.buf_attach_client(0, client.id)
                end
            end
        end,
        get = function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            return #clients > 0
        end,
    })
    :map("<leader>Tl")

--+- LSP: Configure -----------------------------------------+
vim.lsp.config("hyprls", { root_marker = { "hyprland.conf" } })

--+- LSP: Enable --------------------------------------------+
local lsps = {
    "ansiblels",
    "autotools_ls",
    "bashls",
    "basedpyright",
    "ccls",
    "cmake",
    "cssls",
    "css_variables",
    "docker_compose_language_service",
    "dockerls",
    "lua_ls",
    "hyprls",
    "nil_ls",
    "pug",
    "svelte",
}

for _, lsp in ipairs(lsps) do
    vim.lsp.enable(lsp)
end

--+- Support: Check Installation Status ------------------------+
local blacklist = {}
local checked_filetypes = {}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyLspCheckInstallation", { clear = true }),
    callback = function(event)
        local ft = event.match

        -- Skip if we've already checked this filetype
        if checked_filetypes[ft] then
            return
        end

        -- Mark this filetype as checked
        checked_filetypes[ft] = true

        -- Get LSPs applicable to this filetype
        local applicable_lsps = {}
        for _, lsp_name in ipairs(lsps) do
            -- Get LSP config to check its filetypes
            local config = vim.lsp.config[lsp_name]
            if config and config.filetypes then
                -- Check if current filetype is in this LSP's supported filetypes
                if vim.tbl_contains(config.filetypes, ft) then
                    table.insert(applicable_lsps, lsp_name)
                end
            end
        end

        -- Skip if no applicable LSPs for this filetype
        if #applicable_lsps == 0 then
            return
        end

        -- Check for missing LSPs
        local missing_lsps = {}
        for _, lsp_name in ipairs(applicable_lsps) do
            if not vim.tbl_contains(blacklist, lsp_name) then
                local config = vim.lsp.config[lsp_name]
                if config and config.cmd then
                    local cmd = type(config.cmd) == "function" and config.cmd() or config.cmd
                    if type(cmd) == "table" and #cmd > 0 then
                        local executable = cmd[1]
                        if vim.fn.executable(executable) == 0 then
                            table.insert(missing_lsps, { name = lsp_name, cmd = executable })
                        end
                    end
                end
            end
        end

        -- Notify user about missing LSPs for this filetype
        if #missing_lsps > 0 then
            local message = "Missing LSP servers for " .. ft .. ":\n"
            for _, lsp in ipairs(missing_lsps) do
                message = message .. "  - " .. lsp.name .. ": " .. lsp.cmd .. "\n"
            end
            vim.notify(message, vim.log.levels.WARN)
        end
    end,
})
