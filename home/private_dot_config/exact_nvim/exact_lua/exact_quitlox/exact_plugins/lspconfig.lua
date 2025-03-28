-- +---------------------------------------------------------+
-- | neovim/nvim-lspconfig: Collection of LSP Configurations |
-- +---------------------------------------------------------+

--+- Inlay Hints --------------------------------------------+
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
local function set_keybindings(bufnr)
    -- stylua: ignore start
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ float = true, severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Prev Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ float = true, severity = { min = vim.diagnostic.severity.INFO } }) end, { desc = "Next Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[w", function() vim.diagnostic.goto_prev({ float = true, severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Prev Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]w", function() vim.diagnostic.goto_next({ float = true, severity = { min = vim.diagnostic.severity.WARN } }) end, { desc = "Next Diagnostic", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error", buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set("n", "gs", "<cmd> Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", { desc = "Workspace Symbols", buffer = bufnr, silent = true, noremap = true })
    -- stylua: ignore end
    vim.keymap.set("n", "g<Enter>", "<cmd>lua require('fastaction').code_action()<cr>", { buffer = bufnr, silent = true, desc = "Code Action" })
    vim.keymap.set("v", "g<Enter>", "<cmd>lua require('fastaction').range_code_action()<cr>", { buffer = bufnr, silent = true, desc = "Code Action (Range)" })

    vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr, silent = true, noremap = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachKeybinding", { clear = true }),
    desc = "Attach LSP keybindings",
    callback = function(args)
        set_keybindings(args.buf)
    end,
})

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

--+- LSP: Hyperlang -----------------------------------------+
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.hl", "hypr*.conf" },
    group = vim.api.nvim_create_augroup("MyHyprLangLsp", { clear = true }),
    callback = function(event)
        vim.lsp.start({
            name = "hyprlang",
            cmd = { "hyprls" },
            root_dir = vim.fn.getcwd(),
        })
    end,
})

--+- LSP: Javascript / Typescript ---------------------------+
require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        ---@diagnostic disable-next-line: assign-type-mismatch
        args = { vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "vscode-js-debug"), "${port}" },
    },
}

for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }
end

-- FIXME: To be able to use these configurations again, install the required dependencies.
-- See https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
-- { "microsoft/vscode-js-debug", build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git reset --hard HEAD", version = "v1.*" },

--+- LSP: Python --------------------------------------------+
---@diagnostic disable-next-line: missing-fields
require("lspconfig").pyright.setup({
    on_attach = function(client, bufnr)
        local function filter_diagnostics(diagnostic)
            if diagnostic.source ~= "Pyright" then
                return true
            end

            -- Just disable 'is not accessed' altogether
            if string.match(diagnostic.message, '".+" is not accessed') then
                return false
            end
            return true
        end

        local function custom_on_publish_diagnostics(a, params, client_id, c, config)
            vim.tbl_filter(filter_diagnostics, params.diagnostics)
            vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
        end

        client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
    end,
})

--+- LSP: Other ---------------------------------------------+
require("lspconfig").ansiblels.setup({})
require("lspconfig").bashls.setup({})
require("lspconfig").ccls.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").svelte.setup({
    -- Add filetypes for the server to run and share info between files
    filetypes = { "typescript", "javascript", "svelte", "html", "css" },
})
require("lspconfig").texlab.setup({})
