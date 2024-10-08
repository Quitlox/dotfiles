-- +---------------------------------------------------------+
-- | dnlhc/glance.nvim: Code Lens                            |
-- +---------------------------------------------------------+

local custom_before_open = function(results, open, jump, method)
    -- Always show Glance for references | implementations
    if method == "references" or method == "implementations" then
        open(results)
        return
    end

    -- For definitions | type definitions, jump to the first result
    if #results == 1 then
        jump(results[1])
    else
        open(results)
    end
end

local actions = require("glance").actions
---@diagnostic disable-next-line: missing-fields
require("glance").setup({
    hooks = {
        before_open = custom_before_open,
    },
    mappings = {
        list = {
            ["<leader>l"] = false,
            ["i"] = actions.enter_win("preview"),
            ["<C-t>"] = actions.quickfix,
        },
        preview = {
            ["Q"] = actions.close,
            ["<leader>l"] = false,
            ["q"] = actions.enter_win("list"),
            ["<C-t>"] = actions.quickfix,
        },
    },
    use_trouble_qf = true,
})

vim.keymap.set("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Go Definition" })
vim.keymap.set("n", "gi", "<CMD>Glance implementations<CR>", { desc = "Go Implementation" })
vim.keymap.set("n", "gt", "<CMD>Glance type_definitions<CR>", { desc = "Go Type Definition" })
vim.keymap.set("n", "gr", "<CMD>Glance references<CR>", { desc = "Go References" })

-- +---------------------------------------------------------+
-- | lewis6991/hover.nvim: Hover                             |
-- +---------------------------------------------------------+

vim.o.mousemoveevent = true

require("hover").setup({
    init = function()
        -- Require providers
        require("hover.providers.lsp")
        require("hover.providers.dap")
        require("hover.providers.man")
    end,
})

vim.keymap.set("n", "gh", "<cmd>lua require('hover').hover()<cr>", { desc = "Hover" })
vim.keymap.set("n", "K", "<cmd>lua require('hover').hover()<cr>", { desc = "Hover" })
vim.keymap.set("n", "gK", "<cmd>lua require('hover').hover_select()<cr>", { desc = "Hover Select" })

-- +---------------------------------------------------------+
-- | ray-x/lsp_signature.nvim: Signature Help                |
-- +---------------------------------------------------------+

local lsp_signature_config = {
    hint_prefix = "  ",
}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyLspAttachDisableVirtualText", { clear = true }),
    desc = "Disable Virtual Diagnostic Hints",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then return end

        require("lsp_signature").on_attach(lsp_signature_config, bufnr)
    end,
})

--+- Toggle -------------------------------------------------+
vim.g.lsp_signature_toggle_enabled = 1

local lsp_signature_toggle = require("quitlox.util.toggle").wrap({
    name = "Signature Help",
    get = function() return vim.g.lsp_signature_toggle_enabled == 1 end,
    set = function(state) vim.g.lsp_signature_toggle_enabled = require("lsp_signature").toggle_float_win() end,
})

require("legendary").commands({
    { ":LspSignatureToggle", lsp_signature_toggle, description = "Toggle LSP Signature Help" },
})

-- +---------------------------------------------------------+
-- | icholy/lsplinks.nvim: Support for                       |
-- | textDocument/documentLink                               |
-- +---------------------------------------------------------+

require("lsplinks").setup()
vim.keymap.set("n", "gx", "<cmd>lua require('lsplinks').gx()<cr>", { desc = "Go to document link" })

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
        if client == nil then return end

        if vim.tbl_contains(workspace_diagnostic_whitelist, client.name) then
            require("workspace-diagnostics").populate_workspace_diagnostics(client, buffer) -- stylua: ignore
        end
    end,
})
