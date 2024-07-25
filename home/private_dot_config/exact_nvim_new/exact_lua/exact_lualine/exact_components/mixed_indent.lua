local M = require("lualine.component"):extend()

function M:init(options)
    options.icon = options.icon or { "", name = "MixedIndent" }
    options.color = options.color or "DiagnosticError"
    M.super.init(self, options)
end

-- Function to check if mixed indentation exists in the file
local function has_mixed_indentation()
    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]

    -- Search for spaces and tabs in the file
    local space_indent = vim.fn.search(space_pat, "nwc")
    local tab_indent = vim.fn.search(tab_pat, "nwc")

    -- Check whether both spaces and tabs are found
    if space_indent > 0 and tab_indent > 0 then return true end

    -- Check if both spaces and tabs are present on the same line
    local mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
    return mixed_same_line > 0
end

-- Function to determine which type of indentation is more dominant
local function get_dominant_indent_type()
    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]

    -- Count occurrences of space and tab indentations
    local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
    local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total

    -- Return the beginning line number of the less dominant indentation type
    if space_indent_cnt > tab_indent_cnt then
        return vim.fn.search(tab_pat, "nwc")
    else
        return vim.fn.search(space_pat, "nwc")
    end
end

-- Main update_status function
function M:update_status()
    -- Check for mixed indentation and return if none found
    if not has_mixed_indentation() then return "" end

    -- Find and return the beginning line number of the less dominant indentation type
    local dominant_indent_line = get_dominant_indent_type()
    return "" .. dominant_indent_line
end
