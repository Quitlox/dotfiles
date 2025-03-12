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
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    cmdline = {
        keymap = { preset = "cmdline" },
        completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
        },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = true } },

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
        default = { "git", "conventional_commits", "lazydev", "lsp", "path", "buffer", "env" },
        providers = {
            buffer = {
                score_offset = -3,
            },
            conventional_commits = {
                name = "Conventional Commits",
                module = "blink-cmp-conventional-commits",
                enabled = function()
                    return vim.bo.filetype == "gitcommit"
                end,
                ---@module 'blink-cmp-conventional-commits'
                ---@type blink-cmp-conventional-commits.Options
                opts = {},
            },
            dap = {
                name = "dap",
                module = "blink.compat.source",
                enabled = function()
                    return require("cmp_dap").is_dap_buffer()
                end,
            },
            env = {
                name = "Env",
                module = "blink-cmp-env",
                --- @type blink-cmp-env.Options
                opts = {},
                override = {
                    get_trigger_characters = function()
                        return { "$" }
                    end,
                    should_show_items = function(source, context, items)
                        return vim.startswith(context.get_keyword(), "$")
                    end,
                },
                min_keyword_length = 1,
            },
            git = { module = "blink-cmp-git", name = "Git" },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            path = { opts = { trailing_slash = false, label_trailing_slash = true } },
            snippets = { opts = { search_paths = { vim.fn.stdpath("config") .. "/nvim/snippets" } } },
        },
    },
    -- Experimental signature help support
    signature = { enabled = true },
})
