-- +---------------------------------------------------------+
-- | lewis6991/hover.nvim: Hover                             |
-- +---------------------------------------------------------+

--+- Neovim Options -----------------------------------------+
vim.o.mousemoveevent = true

--+- Setup --------------------------------------------------+
require("hover").config({
    providers = {
        { module = "hover.providers.fold_preview", priority = 1004 },
        { module = "hover.providers.diagnostic", priority = 1003 },
        { module = "hover.providers.lsp", priority = 1001 },
        { module = "hover.providers.dap", priority = 1001 },
        { module = "hover.providers.man", priority = 150 },
    },
    preview_opts = {
        max_width = 80,
    },
})

--+- Keymaps ------------------------------------------------+
local function enter_hover()
    local api = vim.api
    local hover_win = vim.b.hover_preview

    if not hover_win or not api.nvim_win_is_valid(hover_win) then
        require("hover").hover({})
    end

    if hover_win and api.nvim_win_is_valid(hover_win) then
        api.nvim_set_current_win(hover_win)
    end
end

-- stylua: ignore start
vim.keymap.set("n", "K", require('hover').hover, { desc = "Hover" })
vim.keymap.set("n", "gK", enter_hover, { desc = "Hover Enter" })
-- stylua: ignore end

--+- Custom -------------------------------------------------+
-- Vibe-coded garbage to reflow hover documentation to remove hard line breaks
-- i.e. a single newline should not result in a line break, double newline should.

local function reflow_hover_markdown(content)
    if type(content) ~= "string" then
        return content
    end

    -- Collect links and replace with numbered references
    local link_refs = {}
    local link_counter = 0

    content = content:gsub("%[([^%]]+)%]%(([^%)]+)%)", function(text, url)
        link_counter = link_counter + 1
        url = url:gsub("[\n\r\t]", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
        link_refs[link_counter] = url or ""
        return string.format("[%s][%d]", text, link_counter)
    end)

    local lines = vim.split(content, "\n", { plain = true })
    local result = {}
    local paragraph = {}
    local in_list_item = false -- Track if we're inside a list item

    local function flush()
        if #paragraph > 0 then
            table.insert(result, table.concat(paragraph, " "))
            paragraph = {}
        end
    end

    for i, line in ipairs(lines) do
        local trimmed = line:match("^%s*(.-)%s*$") or ""

        local is_empty = line == ""
        local is_list = line:match("^%s*[%*%+%-]%s") or line:match("^%s*%d+%.%s")
        local is_special = line:match("^```") or line:match("^#+%s") or line:match("^%s*>") or line:match("^%s*|") or line:match("^%-%-%-")
        local is_indented = line:match("^%s+%S")

        if is_empty or is_special or (is_list and #paragraph > 0) then
            flush()
            in_list_item = false
        end

        if is_empty then
            table.insert(result, "")
        elseif is_special then
            table.insert(result, line)
        elseif is_list then
            table.insert(result, line)
            in_list_item = true
        elseif is_indented and in_list_item and #result > 0 then
            -- Continuation of list item - append to previous line
            result[#result] = result[#result] .. " " .. trimmed
        elseif trimmed ~= "" then
            table.insert(paragraph, trimmed)
            in_list_item = false
        end
    end

    flush()

    -- Add link references at the end if any
    if link_counter > 0 then
        table.insert(result, "")
        table.insert(result, "---")
        for i = 1, link_counter do
            local url = link_refs[i] or ""
            table.insert(result, string.format("[%d]: %s", i, url))
        end
    end

    return table.concat(result, "\n")
end

local original_convert = vim.lsp.util.convert_input_to_markdown_lines
vim.lsp.util.convert_input_to_markdown_lines = function(input, contents_format)
    -- Safely call the original function
    local ok, lines = pcall(original_convert, input, contents_format)
    if not ok or type(lines) ~= "table" then
        return lines or {}
    end

    -- Only reflow if we have valid content
    if #lines > 0 then
        local ok2, content = pcall(table.concat, lines, "\n")
        if not ok2 then
            return lines
        end

        local ok3, reflowed = pcall(reflow_hover_markdown, content)
        if not ok3 then
            return lines
        end

        -- Ensure we return a proper array without embedded newlines
        local ok4, result = pcall(vim.split, reflowed, "\n", { plain = true, trimempty = false })
        if not ok4 then
            return lines
        end

        return result
    end

    return lines
end
