---@diagnostic disable: need-check-nil

local ok_cmp, cmp = pcall(require, "cmp")
local ok_lspkind, lspkind = pcall(require, "lspkind")
local ok_luasnip, luasnip = pcall(require, "luasnip")
if not (ok_cmp and ok_lspkind and ok_luasnip) then
    return
end

vim.o.completeopt = "menu,menuone,noselect"

local completion_enabled = function()
    local context = require("cmp.config.context")
    -- if vim.api.nvim_get_mode().mode ~= "c" and not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment") then
    --     -- Disable completion when typing comments (but not in command mode)
    --     return false
    -- end

    return true
end

-- VSCode-like completion formatting
local vscode_format = lspkind.cmp_format({
    mode = "symbol_text",
    preset = "codicons",

    maxwidth = 50,
    ellipsis_char = "...",
    -- Add visual names for the sources
    menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
        cmdline_history = "[History]",
    },
})

-- Hover Documentation
local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        -- Plugin: Saecki/crates.nvim
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

vim.keymap.set("n", "K", show_documentation, { noremap = true, silent = true })

function select_next_completion_item(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- Note: This is in the default config, but breaks <tab> when positioned at the end of a word in insert mode
        -- elseif has_words_before() then
        -- 	cmp.complete()
    else
        fallback()
    end
end

function select_prev_completion_item(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end

-- Setup completion
local types = require("cmp.types")
cmp.setup({
    enabled = completion_enabled,
    preselect = types.cmp.PreselectMode.None,
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = vscode_format(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "    (" .. strings[2] .. ")"

            return kind
        end,
    },
    snippet = {
        -- Set the Snippet Engine
        expand = function(args)
            import("luasnip", function(ls)
                ls.lsp_expand(args.body)
            end)
        end,
    },
    -- Enable border around completion
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(select_next_completion_item, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(select_prev_completion_item, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(select_next_completion_item, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(select_prev_completion_item, { "i", "s" }),

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
    }, {
        -- This introduces a new group, meaning that only if the group above has
        -- no completion items, this group is used.
        { name = "path" },
        { name = "buffer" },
        {
            name = "spell",
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return require("cmp.config.context").in_treesitter_capture("spell")
                end,
            },
        },
    }),
})

cmp.setup.filetype("python", {
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- rank python completions starting with underscore last
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Command Line Completion
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "cmdline", max_item_count = 10 },
        { name = "cmdline_history", max_item_count = 15 },
        { name = "path", max_item_count = 15 },
    }),
})
