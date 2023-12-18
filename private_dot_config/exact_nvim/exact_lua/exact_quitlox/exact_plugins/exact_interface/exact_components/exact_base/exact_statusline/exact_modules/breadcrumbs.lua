----------------------------------------------------------------------
--                       [Module] Breadcrumbs                       --
----------------------------------------------------------------------
-- Using the plugin "SmiteshP/nvim-navic"
-- In this file, the navic plugin is setup and attached to the LSP.
-- Furthermore the module is defined with custom behaviour

-- Custom behaviour: Retain the breadcrumbs even while buffer is inactive
local breadcrumbs = function(highlight)
    local navic = require('nvim-navic')

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
