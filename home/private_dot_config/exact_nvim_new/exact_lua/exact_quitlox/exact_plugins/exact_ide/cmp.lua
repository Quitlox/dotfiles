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
    mode = "symbol_text",
    preset = "codicons",

    maxwidth = 35,
    ellipsis_char = "...",
    -- Add visual names for the sources
    menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
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
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = "    (" .. (strings[2] or "") .. ")"

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
        ["<C-n>"] = cmp.mapping(function() require("luasnip").jump(1) end, { "i", "s", "c" }),
        ["<C-p>"] = cmp.mapping(function() require("luasnip").jump(-1) end, { "i", "s", "c" }),
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
        -- }, {
        -- { name = "cmdline" }, -- FIXME: Broken for some reason
        -- { name = "cmdline_history" },
    }),
})

--+- Filetype Sources ---------------------------------------+
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

cmp.setup.filetype("python", {
    sorting = {
        priority_weight = 1,
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
