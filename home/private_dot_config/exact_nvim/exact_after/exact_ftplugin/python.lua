local ok1, _ = pcall(require, "mini.ai")
local ok2, _ = pcall(require, "nvim-treesitter-textobjects.move")
if not ok1 or not ok2 then
    return
end

--+- Treesitter: Customize textobjects ----------------------+
-- stylua: ignore start
local ts_move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.name", "textobjects") end, { desc = "Next Function Start (Python)" })
vim.keymap.set({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.name", "textobjects") end, { desc = "Previous Function Start (Python)" })
vim.keymap.set({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.name", "textobjects") end, { desc = "Next Class Start (Python)" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.name", "textobjects") end, { desc = "Previous Class Start (Python)" })
vim.keymap.set({ "n", "x", "o" }, "]C", function() ts_move.goto_next_start("@class.name", "textobjects") end, { desc = "Next Class Start (Python)" })
vim.keymap.set({ "n", "x", "o" }, "[C", function() ts_move.goto_previous_start("@class.name", "textobjects") end, { desc = "Previous Class Start (Python)" })
-- stylua: ignore end

--+- mini.ai: Customize textobjects -------------------------+
-- Function to check if cursor is in a comment
local function is_in_comment()
    -- First check using syntax highlighting
    local syntax_ids = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
    for _, id in ipairs(syntax_ids) do
        local name = vim.fn.synIDattr(id, "name")
        if name:match("Comment") then
            return true
        end
    end

    -- Fallback to treesitter check
    local parser = vim.treesitter.get_parser()
    if not parser then
        return false
    end

    local tree = parser:parse()[1]
    if not tree then
        return false
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]

    local root = tree:root()
    local node = root:named_descendant_for_range(row, col, row, col)

    while node do
        if node:type() == "comment" then
            return true
        end
        node = node:parent()
    end

    return false
end

--- Create a combined quote text object handler that addresses two specific edge cases
---
--- This function creates a text object handler for quotes that solves two problematic cases:
---
--- 1. Cursor-on-closing-quote edge case:
---    When the cursor is positioned on a closing quote, the standard treesitter
---    approach fails because the cursor is technically outside the @string.inner
---    region. This causes unexpected behavior where commands like `ci"` would
---    jump to the next string instead of operating on the current string.
---
---    Our solution inspects all possible string regions from treesitter and
---    explicitly handles this edge case by calculating the "closest" string region
---    when the cursor isn't inside any region, ensuring commands work intuitively
---    even when the cursor is on a quote character.
---
--- 2. Quotes in comments:
---    Treesitter properly recognizes actual string nodes in code, but ignores
---    quote characters inside comments (since they're not real strings in the AST).
---    This would prevent quote text objects from working inside comments.
---
---    Our solution detects when the cursor is inside a comment (using both syntax
---    highlighting and treesitter) and falls back to the default pattern-based
---    matching behavior, which works for any quote characters regardless of context.
---
--- @return function A text object handler function compatible with mini.ai custom textobjects
function create_quote_textobject()
    -- Define pattern-based behavior for quotes (used for fallback in comments)
    local pattern_specs = {
        ["'"] = { "%b''", "^.().*().$" },
        ['"'] = { '%b""', "^.().*().$" },
        ["`"] = { "%b``", "^.().*().$" },
    }

    return function(ai_type, id, opts)
        -- If in comment, use pattern matching instead of treesitter
        if is_in_comment() then
            return pattern_specs[id]
        end

        -- Otherwise, use treesitter with edge case handling for cursor on closing quote
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local cursor_line = cursor_pos[1]
        local cursor_col = cursor_pos[2] + 1 -- 1-indexed

        -- Create a treesitter spec for both regular strings and f-strings
        local ts_spec = require("mini.ai").gen_spec.treesitter({
            a = { "@string.outer", "@fstring.outer" },
            i = { "@string.inner", "@fstring.inner" },
        })

        -- Get all possible string regions from treesitter
        local regions = ts_spec(ai_type, id, opts)

        -- Fix edge case: cursor on closing quote
        -- Filter and find the best region based on cursor position
        local best_region
        local min_distance = math.huge

        for _, region in ipairs(regions) do
            -- Check if cursor is inside this region
            local is_inside = (
                region.from.line <= cursor_line
                and region.to.line >= cursor_line
                and (region.from.line < cursor_line or region.from.col <= cursor_col)
                and (region.to.line > cursor_line or region.to.col >= cursor_col)
            )

            if is_inside then
                -- When inside a region, this should be the best match
                return region
            else
                -- Otherwise, find closest next region
                -- We prioritize regions that begin after the cursor
                local dist_from = math.abs(region.from.line - cursor_line) * 1000 + math.abs(region.from.col - cursor_col)
                local dist_to = math.abs(region.to.line - cursor_line) * 1000 + math.abs(region.to.col - cursor_col)
                local dist = math.min(dist_from, dist_to)

                if region.from.line >= cursor_line then
                    if dist < min_distance then
                        min_distance = dist
                        best_region = region
                    end
                end
            end
        end

        return best_region
    end
end

-- set up our custom textobjects
local gen_spec = require("mini.ai").gen_spec
vim.b.miniai_config = {
    custom_textobjects = {
        ['"'] = create_quote_textobject(),
        ["'"] = create_quote_textobject(),
        ["`"] = create_quote_textobject(),
        -- We limit argument to brackets, to avoid conflict with typehint brackets
        a = gen_spec.argument({ brackets = { "%b()" } }),
    },
}
