----------------------------------------------------------------------
--                       [Module] Breadcrumbs                       --
----------------------------------------------------------------------
-- Using the plugin "SmiteshP/nvim-navic"
--
-- Custom behaviour: Retain the breadcrumbs even while buffer is inactive

local breadcrumbs = function(highlight)
    -- Import Navic
    local status_ok, navic = pcall(require, "nvim-navic")
    if not status_ok then return "" end

    -- Wrapper around navic to remember last value
    vim.b.navic_last = ""
    local get_location = function()
        if navic.is_available() then
            vim.b.navic_last = navic.get_location({ highlight = highlight })
        end
        if vim.b.navic_last == nil then return "" end

        return vim.b.navic_last
    end

    return { get_location, separator = { left = "", right = "" } }
end

return breadcrumbs
