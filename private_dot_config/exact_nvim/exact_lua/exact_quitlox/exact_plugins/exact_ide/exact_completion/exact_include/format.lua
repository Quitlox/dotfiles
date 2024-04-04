----------------------------------------------------------------------
--                        Completion: Format                        --
----------------------------------------------------------------------
-- The formatter of cmp determines the visuals of the completion menu.

local lspkind = require("lspkind")

-- VSCode-like completion formatting
-- TODO: Fix color of completion menu
local vscode_format = lspkind.cmp_format({
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
        latex_symbols = "[Latex]",
        cmdline_history = "[History]",
    },

    before = require("tailwind-tools.cmp").lspkind_format
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

return formatting
