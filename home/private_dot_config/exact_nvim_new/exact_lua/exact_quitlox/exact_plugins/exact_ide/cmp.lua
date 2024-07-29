-- +---------------------------------------------------------+
-- | hrsh7th/nvim: Completion Framework                      |
-- +---------------------------------------------------------+

--+- Vim Options --------------------------------------------+
vim.o.completeopt = "menu,menuone,noselect"

--+- Behaviour ----------------------------------------------+
local next_completion = function(fallback, count)
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.select_next_item({ count = count or 1 })
    elseif vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
    else
        fallback()
    end
end

local prev_completion = function(fallback, count)
    local cmp = require("cmp")
    if cmp.visible() then
        cmp.select_prev_item({ count = count or 1 })
    elseif vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
    else
        fallback()
    end
end

local function scroll_completion_down()
    local cmp = require("cmp")

    -- If the Documentation View is visible, scroll the documentation
    if cmp.core.view.docs_view:visible() then
        cmp.core.view:scroll_docs(4)
        return
    end

    -- Otherwise, jump through half of the visible entries
    if cmp.core.view.custom_entries_view:visible() then
        local window_info = cmp.core.view.custom_entries_view:info()
        local height = window_info.height
        -- FIXME: This doens't work for some reason
        return cmp.select_next_item({ count = math.floor(height / 2) })
    end
end

local function scroll_completion_up()
    local cmp = require("cmp")

    -- If the Documentation View is visible, scroll the documentation
    if cmp.core.view.docs_view:visible() then
        cmp.core.view:scroll_docs(-4)
        return
    end

    -- Otherwise, jump through half of the visible entries
    if cmp.core.view.custom_entries_view:visible() then
        -- attributes: border_info, col, height, inner_height, inner_width, row, scrollabe, scrollbar_offset, width
        local window_info = cmp.core.view.custom_entries_view:info()
        local height = window_info.height
        cmp.select_prev_item({ count = math.floor(height / 2) })
    end
end

--+- Interface ----------------------------------------------+
local vscode_format = require("lspkind").cmp_format({
    mode = "symbol",
    preset = "codicons",

    maxwidth = 35,
    ellipsis_char = "...",
    -- Add visual names for the sources
    menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
        cmdline_history = "[History]",
    },

    before = function(entry, vim_item)
        local tailwind_whitelist = { "html", "svelte" }

        if tailwind_whitelist[vim.bo.filetype] then return require("tailwind-tools.cmp").lspkind_format(entry, vim_item) end

        return vim_item
    end,
})

local format = function(entry, vim_item)
    -- VSCode Kind
    local kind = vscode_format(entry, vim_item)
    -- local strings = vim.split(kind.kind, "%s", { trimempty = true }) -- requires symbol_text for lspkind
    kind.kind = " " .. (kind.kind or "") .. " "
    -- kind.menu = "    (" .. (strings[2] or "") .. ")" -- name of kind
    -- kind.menu = "    (" .. (entry.source.name or "") .. ")" -- name of source
    -- kind.menu = "    " .. (kind.menu or "") -- nice name of source
    kind.dup = 0 -- Remove duplicate entries

    return kind
end

local formatting = {
    fields = { require("cmp").ItemField.Kind, require("cmp").ItemField.Abbr, require("cmp").ItemField.Menu },
    format = format,
}

--+- Source: Spell ------------------------------------------+
local spell_options = {
    keep_all_entries = false,
    enable_in_context = function() return require("cmp.config.context").in_treesitter_capture("spell") end,
}

--+- Setup --------------------------------------------------+
local cmp = require("cmp")
cmp.setup({
    enabled = function() return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer() end,
    preselect = require("cmp.types").cmp.PreselectMode.None,
    formatting = formatting,
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    -- Enable border around completion
    window = {
        completion = {
            -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,Blue:PmenuSel",
            col_offset = -3,
            side_padding = 0,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(next_completion, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(prev_completion, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(next_completion, { "i", "s", "c" }),
        ["<C-k>"] = cmp.mapping(prev_completion, { "i", "s", "c" }),
        ["<C-b>"] = cmp.mapping(scroll_completion_up, { "i", "s", "c" }),
        ["<C-f>"] = cmp.mapping(scroll_completion_down, { "i", "s", "c" }),
        ["<C-u>"] = cmp.mapping(scroll_completion_up, { "i", "s", "c" }),
        ["<C-d>"] = cmp.mapping(scroll_completion_down, { "i", "s", "c" }),
        ["<C-space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" }, -- TODO: Do we use default_capabilities
    }, {
        { name = "path" },
    }, {
        { name = "spell", option = spell_options },
        { name = "rg" },
    }),
})

--+- Commandline Sources ------------------------------------+
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
        { name = "cmdline_history" },
    }),
})

--+- Filetype Sources ---------------------------------------+
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

--+- Modify ordering ----------------------------------------+
local python_underscore = function(entry1, entry2)
    -- rank python completions starting with underscore last
    local _, entry1_under = entry1.completion_item.label:find("^_+")
    local _, entry2_under = entry2.completion_item.label:find("^_+")
    entry1_under = entry1_under or 0
    entry2_under = entry2_under or 0
    if entry1_under > entry2_under then
        return false
    elseif entry1_under < entry2_under then
        return true
    end
end

local types = require("cmp.types")

---@type table<integer, integer>
local modified_priority = {
    [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
    [types.lsp.CompletionItemKind.Snippet] = 0, -- top
    [types.lsp.CompletionItemKind.Keyword] = 0, -- top
    [types.lsp.CompletionItemKind.Text] = 100, -- bottom
}
---@param kind integer: kind of completion entry
local function modified_kind(kind) return modified_priority[kind] or kind end

-- FIXME: Should not only be for python
cmp.setup.filetype("python", {
    sorting = {
        priority_weight = 1,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            python_underscore,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
                local kind1 = modified_kind(entry1:get_kind())
                local kind2 = modified_kind(entry2:get_kind())
                if kind1 ~= kind2 then return kind1 - kind2 < 0 end
            end,
            function(entry1, entry2) -- score by lsp, if available
                local t1 = entry1.completion_item.sortText
                local t2 = entry2.completion_item.sortText
                if t1 ~= nil and t2 ~= nil and t1 ~= t2 then return t1 < t2 end
            end,
            -- cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
