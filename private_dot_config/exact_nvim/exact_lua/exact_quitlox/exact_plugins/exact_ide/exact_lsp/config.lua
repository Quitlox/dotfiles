--  +----------------------------------------------------------+
--  | LSP Keybindings                                          |
--  +----------------------------------------------------------+

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
            "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
            "Prev Error",
        },
        ["]e"] = {
            "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
            "Prev Error",
        },
        -- Add Go mappings for LSP Symbol navigation
        g = {
            name = "Go",
            D = { "<cmd>Lspsaga peek_definition<cr>", "Go Declaration" },
            d = { "<cmd>Lspsaga goto_definition<cr>", "Go Definition" },
            i = { function() vim.lsp.buf.implementation() end, "Go Implementation" },
            s = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Symbols" },
            t = { "<cmd>Lspsaga peek_type_definition<cr>", "type Definition" },
            R = { "<cmd>Lspsaga rename ++project<cr>", "Go Rename" },
            r = { "<cmd>Lspsaga lsp_finder<cr>", "Go References" },
            h = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
            f = { function() vim.lsp.buf.format({ bufnr = bufnr }) end, "Format" },
            a = { "<cmd>Lspsaga code_action<cr>", "Action" },
        },
        K = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
    }, bufopts)

    -- Rename
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
    -- Signature Help
    vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help)
end

--  +----------------------------------------------------------+
--  | General Server Settings                                  |
--  +----------------------------------------------------------+

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Cursor Highlight
    require("illuminate").on_attach(client)
    -- Default Mappings
    set_keybindings(bufnr)

    -- Disable default inline diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = false,
    })

    -- Breadcrumbs
    if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufnr) end
end

local make_capabilities = function()
    -- Completion Capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- Snippet support provided by LuaSnip
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    return capabilities
end
----------------------------------------------------------------------
--                              Mason                               --
----------------------------------------------------------------------
-- Mason is a tool for easily installing third-party language-servers,
-- formatters, linters, debuggers and other utilities for Neovim.
-- Mason also takes care of automatically registering language-servers to LSP
-- and tools to NullLs.

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- These need to be ran before nvim-lspconfig
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",

        -- navic used in quitlox.plugins.lsp.include.common
        dependencies = { "SmiteshP/nvim-navic" },

        opts = {
            automatic_installation = false,
            ensure_installed = { "jsonls" }, -- For Neoconf configuration file completion to work out of the box
        },

        config = function(_, opts)
            local lspconfig = require("lspconfig")

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup(opts)

            local capabilities = make_capabilities()

            -- Automatic setup of all LSPs
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                -- Manually configured servers
                ["clangd"] = function()
                    -- TODO: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
                    local clang_capabilities = capabilities
                    clang_capabilities.offsetEncoding = { "utf-16" }

                    lspconfig.clangd.setup({
                        capabilities = clang_capabilities,
                        on_attach = on_attach,
                    })
                end,
                ["jsonls"] = function()
                    local schemastore = require("schemastore")
                    lspconfig.jsonls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            json = {
                                schemas = schemastore.json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    })
                end,
                ["lua_ls"] = function()
                    -- Developer support for Neovim configuration and Neovim plugin development
                    -- Needs to be loaded before lspconfig
                    require("neodev").setup({
                        library = { plugins = { "nvim-dap-ui" }, types = true },
                    })

                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = "Replace",
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
                -- NOTE: Thanks to rust_analyzer, lazy loading DAP and all related plugins
                -- is not possible
                ["rust_analyzer"] = function()
                    local rt = require("rust-tools")
                    rt.setup({
                        server = {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                -- Overwrite Join Keys keybinding
                                -- stylua: ignore
                                -- vim.keymap.set("n", "J", rt.join_lines.join_lines, { noremap = true, buffer = bufnr })

                                -- Hover actions
                                -- stylua: ignore
                                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions,
                                    { noremap = true, buffer = bufnr })
                                -- Code action groups
                                -- stylua: ignore
                                vim.keymap.set("n", "ga", rt.code_action_group.code_action_group,
                                    { noremap = true, buffer = bufnr })

                                return on_attach(client, bufnr)
                            end,
                        },
                    })
                end,
                ["yamlls"] = function()
                    local yaml_companion = require("yaml-companion")

                    -- TODO: Add keybinding for :Telescope yaml_schema
                    -- TODO: For fancyness, I should check whether a schema is found upon opening
                    -- a yaml file. If not, a popup should appear to hint the user to open
                    -- :Telescope yaml_schema to select a schema.
                    local cfg = yaml_companion.setup({
                        lspconfig = {
                            capabilities = capabilities,
                            on_attach = on_attach,
                        },
                    })

                    -- Add as a telescope extension
                    require("telescope").load_extension("yaml_schema")
                    -- Setup LSP
                    lspconfig.yamlls.setup(cfg)
                end,
                ["tsserver"] = function()
                    local typescript_capabilities = make_capabilities()
                    typescript_capabilities.documentFormattingProvider = false
                    require("typescript").setup({
                        server = {
                            on_attach = on_attach,
                            capabilities = typescript_capabilities,
                        },
                    })
                end,
                ["pyright"] = function()
                    local function filter(arr, func)
                        -- Filter in place
                        -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
                        local new_index = 1
                        local size_orig = #arr
                        for old_index, v in ipairs(arr) do
                            if func(v, old_index) then
                                arr[new_index] = v
                                new_index = new_index + 1
                            end
                        end
                        for i = new_index, size_orig do
                            arr[i] = nil
                        end
                    end

                    require("lspconfig").pyright.setup({
                        on_attach = function(client, bufnr)
                            local function filter_diagnostics(diagnostic)
                                if diagnostic.source ~= "Pyright" then return true end

                                -- Just disable 'is not accessed' altogether
                                if string.match(diagnostic.message, '".+" is not accessed') then return false end

                                return true
                            end

                            local function custom_on_publish_diagnostics(a, params, client_id, c, config)
                                filter(params.diagnostics, filter_diagnostics)
                                vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
                            end

                            client.handlers["textDocument/publishDiagnostics"] =
                                vim.lsp.with(custom_on_publish_diagnostics, {})
                            on_attach(client, bufnr)
                        end,
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },

    ----------------------------------------
    -- Language Server Protocol (LSP) plugins
    ----------------------------------------
    -- Lazy load language plugins when the corresponding is called

    ----- LuaDev -----
    { "folke/neodev.nvim",                         version = "", config = false },
    ----- Ansible -----
    { "mfussenegger/nvim-ansible" },
    ----- YAML -----
    { "someone-stole-my-name/yaml-companion.nvim", lazy = true,  version = "" },
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    { "b0o/SchemaStore.nvim",                      lazy = true },
    ----- Rust -----
    { "simrat39/rust-tools.nvim",                  lazy = true },
    ----- Typescript -----
    { "jose-elias-alvarez/typescript.nvim",        lazy = false },
    {
        "dmmulroy/tsc.nvim",
        lazy = false,
        dependencies = { "mrjones2014/legendary.nvim" },
        config = true,
        init = function()
            require("legendary").command({
                ":TSC",
                description = "Perform type checking on the current project",
            })
        end,
    },
}
