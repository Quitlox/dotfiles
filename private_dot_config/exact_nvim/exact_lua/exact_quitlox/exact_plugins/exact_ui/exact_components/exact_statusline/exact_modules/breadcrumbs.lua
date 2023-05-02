----------------------------------------------------------------------
--                       [Module] Breadcrumbs                       --
----------------------------------------------------------------------
-- Using the plugin "SmiteshP/nvim-navic"
-- In this file, the navic plugin is setup and attached to the LSP.
-- Furthermore the module is defined with custom behaviour

-- Require
local navic = require('nvim-navic')

-- Set Highlight Groups equal to those used in the completion menu
-- The completion menu highlights are in turn set to those corresponding to the
-- vscode dark theme.
vim.api.nvim_set_hl(0, "NavicIconsFile", { link = "CmpItemKindFile" })
vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "CmpItemKindModule" })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "CmpItemKindNamespace" })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "CmpItemKindPackage" })
vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "CmpItemKindClass" })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "CmpItemKindMethod" })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "CmpItemKindProperty" })
vim.api.nvim_set_hl(0, "NavicIconsField", { link = "CmpItemKindField" })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "CmpItemKindConstructor" })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "CmpItemKindEnum" })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "CmpItemKindInterface" })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "CmpItemKindFunction" })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "CmpItemKindConstant" })
vim.api.nvim_set_hl(0, "NavicIconsString", { link = "CmpItemKindString" })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "CmpItemKindNumber" })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "CmpItemKindBoolean" })
vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "CmpItemKindArray" })
vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "CmpItemKindObject" })
vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "CmpItemKindKey" })
vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "CmpItemKindNull" })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "CmpItemKindEnumMember" })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "CmpItemKindStruct" })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "CmpItemKindEvent" })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "CmpItemKindOperator" })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "CmpItemKindTypeParameter" })
vim.api.nvim_set_hl(0, "NavicText", { link = "CmpItemKindText" })
vim.api.nvim_set_hl(0, "NavicSeparator", { link = "CmpItemKindSeparator" })

-- Setup function
navic.setup({
    highlight = true,
    -- Override icons with VSCode icons
    icons = {
        File = "  ",
        Module = "  ",
        Namespace = "  ",
        Package = "  ",
        Class = "  ",
        Method = "  ",
        Property = "  ",
        Field = "  ",
        Constructor = "  ",
        Enum = "  ",
        Interface = "  ",
        Function = "  ",
        Variable = "  ",
        Constant = "  ",
        String = "  ",
        Number = "  ",
        Boolean = "  ",
        Array = "  ",
        Object = "  ",
        Key = "  ",
        Null = "  ",
        EnumMember = "  ",
        Struct = "  ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
    },
})



-- Custom behaviour: Retain the breadcrumbs even while buffer is inactive
local breadcrumbs = function(highlight)
    -- Wrapper around navic to remember last value
    vim.b.navic_last = ""
    local get_location = function()
        if navic.is_available() then vim.b.navic_last = navic.get_location({ highlight = highlight }) end
        if vim.b.navic_last == nil then return "" end

        return vim.b.navic_last
    end

    return { get_location, separator = { left = "", right = "" } }
end

return breadcrumbs
