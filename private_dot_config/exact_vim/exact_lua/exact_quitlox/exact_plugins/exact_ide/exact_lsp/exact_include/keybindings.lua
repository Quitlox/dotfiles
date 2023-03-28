----------------------------------------------------------------------
--                         LSP Keybindings                          --
----------------------------------------------------------------------

-- Custom formatting function to support disabling servers
local lsp_format = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            if client.name == "lua_ls" then return false end
            return true
        end,
        bufnr = bufnr,
    })
end

local function set_keybindings(bufnr)
    -- Default buffer options
    local bufopts = { silent = true, noremap = true, buffer = bufnr }
    -- Require which-key
    local wk = require("which-key")

    wk.register({
        -- Add [e and ]e for navigating to Error Diagnostics
        -- Add [d and ]d for navigating to any Diagnostics
        ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev Diagnostic" },
        ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Prev Diagnostic" },
        ["[e"] = {
            function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
            "Prev Error",
        },
        ["]e"] = {
            function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
            "Prev Error",
        },
        -- Add Go mappings for LSP Symbol navigation
        g = {
            name = "Go",
            D = { "<cmd>Lspsaga peek_definition<cr>", "Go Declaration" },
            d = { "<cmd>Lspsaga goto_definition<cr>", "Go Definition" },
            i = { vim.lsp.buf.implementation, "Go Implementation" },
            s = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Symbols" },
            t = { "<cmd>Lspsaga peek_type_definition<cr>", "type Definition" },
            R = { "<cmd>Lspsaga rename ++project<cr>", "Go Rename" },
            r = { "<cmd>Lspsaga lsp_finder<cr>", "Go References" },
            h = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
            f = { lsp_format, "Format" },
            a = { "<cmd>Lspsaga code_action<cr>", "Action" },
        },
        K = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
    }, bufopts)

    -- Rename
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
    -- Signature Help
    vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help)
end

return set_keybindings
