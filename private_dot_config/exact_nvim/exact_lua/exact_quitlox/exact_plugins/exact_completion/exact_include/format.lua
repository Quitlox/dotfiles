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
    before = function(entry, vim_item)
        -- Tailwind Colorizer
        -- TODO: Improve formatting
        -- https://github.com/roobert/tailwindcss-colorizer-cmp.nvim/issues/4
        local status_ok, tw_colorizer = pcall(require, "tailwindcss-colorizer-cmp")
        if status_ok then vim_item = tw_colorizer.formatter(entry, vim_item) end
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

return formatting
