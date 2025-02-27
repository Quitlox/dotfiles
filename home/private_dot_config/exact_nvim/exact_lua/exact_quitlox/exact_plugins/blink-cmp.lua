-- +---------------------------------------------------------+
-- | Saghen/blink.cmp: Completion                            |
-- +---------------------------------------------------------+

--+- Integration: set LSP capabilities ----------------------+
require("quitlox.util.lazy").on_module("lspconfig", function()
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    -- Set default server configuration
    require("lspconfig").util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig.util.default_config.capabilities),
    })

    -- Set capabilities for each initialized server
    for server, config in pairs(configs) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
    end
end)

-- TODO: at end of completion, tab should be used to escape parenthesis

require("blink-cmp").setup({
    keymap = {
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Enter>"] = { "accept", "fallback" },
    },
    cmdline = {
        keymap = {
            ["<Tab>"] = { "select_next" },
            ["<S-Tab>"] = { "select_prev" },
            ["<Enter>"] = {},
            ["<C-Space>"] = { "show" },
        },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true },
        list = {
            selection = { preselect = false, auto_insert = true },
        },

        -- Setup mini.icons
        menu = {
            draw = {
                components = {
                    kind_icon = {
                        ellipsis = false,
                        text = function(ctx)
                            local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                            return kind_icon .. " "
                        end,
                        highlight = function(ctx)
                            local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
    },
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            dap = {
                name = "dap",
                module = "blink.compat.source",

                enabled = function()
                    return require("cmp_dap").is_dap_buffer()
                end,
            },
            html_css = {
                name = "html-css",
                module = "blink.compat.source",
            },
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
            path = {
                opts = {
                    trailing_slash = false,
                    label_trailing_slash = true,
                },
            },
            snippets = {
                opts = {
                    search_paths = { vim.fn.stdpath("config") .. "/nvim/snippets" },
                },
            },
        },
    },
    -- Experimental signature help support
    signature = { enabled = true },
})
