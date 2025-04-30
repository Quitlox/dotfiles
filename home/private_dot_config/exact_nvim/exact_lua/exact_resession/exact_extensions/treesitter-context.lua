local M = {}

-- Helper function to check if a module is available
local function has_module(module)
    return package.loaded[module] ~= nil or pcall(require, module)
end

-- Helper function to check if treesitter-context is enabled
local function is_context_enabled()
    -- In nvim-treesitter-context, the enabled state is typically tracked internally
    -- We'll check if the module is loaded and then access its internal state
    if not has_module("treesitter-context") then
        return false
    end

    -- The exact implementation may vary based on how the plugin stores its state
    -- This is a common pattern, but might need adjustment based on the actual implementation
    local context = require("treesitter-context")
    return context and context.enabled ~= false
end

M.on_save = function()
    if not has_module("treesitter-context") then
        return {}
    end

    -- Save the current state of treesitter-context
    local is_enabled = is_context_enabled()

    -- Return the state to be saved in the session
    return { is_enabled = is_enabled }
end

M.on_post_load = function(data)
    if not has_module("treesitter-context") then
        return
    end

    -- Restore the treesitter-context state
    if data and data.is_enabled then
        -- Enable context if it was enabled when the session was saved
        pcall(require("treesitter-context").enable)
    else
        -- Disable context if it was disabled
        pcall(require("treesitter-context").disable)
    end
end

return M
