-- +---------------------------------------------------------+
-- | Saghen/blink.cmp: Completion                            |
-- +---------------------------------------------------------+

--+- Integration: set LSP capabilities ----------------------+
require("_config.util.lazy").on_module("lspconfig", function()
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

local ft_blacklist = { "copilot-chat" }
require("blink-cmp").setup({
    enabled = function()
        return not vim.tbl_contains(ft_blacklist, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end,
    keymap = {
        ["<Tab>"] = {
            "snippet_forward",
            require("sidekick").nes_jump_or_apply,
            "select_next",
            "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Enter>"] = { "accept", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    cmdline = {
        keymap = { preset = "cmdline" },
        -- keymap = { preset = "cmdline", ["/"] = { "accept", "fallback" } },
        sources = { "buffer", "cmdline", "path" },
        completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = true } },
            -- accept = { auto_brackets = { enabled = false } },
        },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = true } },

        -- Setup mini.icons
        menu = {
            draw = {
                columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name", gap = 1 } },
                components = {
                    label = {
                        text = function(ctx)
                            local is_large = false
                            is_large = is_large or (ctx and ctx.item and ctx.item.detail and string.len(ctx.item.detail) > 1000)
                            is_large = is_large or (ctx and ctx.item and ctx.item.labelDetails and ctx.item.labelDetails.description and string.len(ctx.item.labelDetails.description) > 1000)
                            is_large = is_large or (ctx and ctx.item and ctx.item.label_description and string.len(ctx.item.label_description) > 1000)
                            if is_large then
                                return require("blink.cmp.config.completion.menu").default.draw.components.label.text(ctx)
                            else
                                return require("colorful-menu").blink_components_text(ctx)
                            end
                        end,
                        highlight = function(ctx)
                            local is_large = false
                            is_large = is_large or (ctx and ctx.item and ctx.item.detail and string.len(ctx.item.detail) > 1000)
                            is_large = is_large or (ctx and ctx.item and ctx.item.labelDetails and ctx.item.labelDetails.description and string.len(ctx.item.labelDetails.description) > 1000)
                            is_large = is_large or (ctx and ctx.item and ctx.item.label_description and string.len(ctx.item.label_description) > 1000)
                            if is_large then
                                return require("blink.cmp.config.completion.menu").default.draw.components.label.highlight(ctx)
                            else
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end
                        end,
                    },
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
                    source_name = {
                        text = function(ctx)
                            return "(" .. ctx.source_name .. ")"
                        end,
                        highlight = function(ctx)
                            return "BlinkCmpSourceName"
                        end,
                    },
                },
            },
        },
    },
    snippets = { preset = "luasnip" },
    sources = {
        default = { "snippets", "vimtex", "git", "conventional_commits", "lsp", "path", "env", "html-css" },
        per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
            codecompanion = { inherit_defaults = true, "bufname", "ripgrep" },
        },
        providers = {
            buffer = {
                score_offset = -3,
                max_items = 3,
            },
            bufname = {
                name = "bufname",
                module = "blink.compat.source",
            },
            codecompanion = {
                name = "codecompanion",
                module = "codecompanion.providers.completion.blink",
                score_offset = 100,
                override = {
                    --- Ensure that codecompanion source only shows at start of line after slash
                    should_show_items = function(self, context, items)
                        local is_trigger = context.trigger.initial_kind == "trigger_character" and context.trigger.initial_character == "/"
                        if not is_trigger then
                            return true
                        end

                        local line_before_trigger = context.line:sub(1, context.line:find(context.trigger.initial_character))
                        -- Only show at start of line
                        return #line_before_trigger == 1
                    end,
                },
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
                override = {},
            },
            dap = {
                name = "dap",
                module = "blink.compat.source",
                enabled = function()
                    return require("cmp_dap").is_dap_buffer()
                end,
            },
            env = {
                name = "env",
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
            git = {
                module = "blink-cmp-git",
                name = "git",
                override = {
                    should_show_items = function(self, context, items)
                        -- First check original conditions
                        local is_trigger = context.trigger.initial_kind == "trigger_character" and vim.tbl_contains(self:get_trigger_characters(), context.trigger.initial_character)
                        if not is_trigger or context.mode ~= "cmdline" then
                            return false
                        end

                        -- We only want to show the source after whitespace
                        -- TODO: This should probably be fixed in the plugin itself

                        -- Get the line up to the cursor (includes the trigger character)
                        local line_before_cursor = context.line:sub(1, context.cursor[2])

                        -- If the line only has the colon or it's at the beginning, it's fine
                        if #line_before_cursor == 1 then
                            return true
                        end

                        -- Check if the character before the colon is whitespace
                        local char_before_colon = line_before_cursor:sub(#line_before_cursor - 1, #line_before_cursor - 1)
                        return char_before_colon:match("%s") ~= nil
                    end,
                },
            },
            ["html-css"] = { name = "html-css", module = "blink.compat.source" },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            lsp = {
                fallbacks = { "ripgrep" },
                transform_items = function(ctx, items)
                    -- Filter out keyword items
                    local filtered_items = vim.tbl_filter(function(item)
                        return item.kind ~= 14 -- 14 is CompletionItemKind.Keyword
                    end, items)

                    -- Boost score for table keys
                    for _, item in ipairs(filtered_items) do
                        if item.kind == 5 then -- CompletionItemKind.Field
                            item.score_offset = (item.score_offset or 0) + 100
                        end
                    end

                    return filtered_items
                end,
            },
            otter = { name = "otter", module = "blink.compat.source" },
            path = {
                min_keyword_length = 0,
                opts = {
                    trailing_slash = false,
                    label_trailing_slash = true,
                },
                override = {
                    --- Ensure that path completion does not show in codecompanion window (interferes with slash commands)
                    should_show_items = function(self, context, items)
                        local is_trigger = context.trigger.initial_kind == "trigger_character" and context.trigger.initial_character == "/"
                        if is_trigger and vim.tbl_contains(context.providers, "codecompanion") then
                            local line_before_trigger = context.line:sub(1, context.line:find(context.trigger.initial_character))
                            return #line_before_trigger > 1
                        end

                        return true
                    end,
                },
            },
            ripgrep = {
                name = "ripgrep",
                module = "blink-ripgrep",
                opts = {
                    prefix_min_len = 3,
                    project_root_marker = ".git",
                },
            },
            snippets = {
                score_offset = 100,
            },
            vimtex = { name = "vimtex", module = "blink.compat.source" },
        },
    },
    -- Experimental signature help support
    signature = { enabled = true },
})
