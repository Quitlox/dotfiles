-- +---------------------------------------------------------+
-- | windwp/nvim-autopairs: Autopairs                        |
-- +---------------------------------------------------------+

local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local npairs = require("nvim-autopairs")
local ts_conds = require("nvim-autopairs.ts-conds")

--+- Setup --------------------------------------------------+
npairs.setup({
    disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
})

--+- Helper: Default quote creator --------------------------+
-- Copied from nvim-autopairs/rules/basic.lua
local function quote_creator(opt)
    local quote = function(...)
        local move_func = opt.enable_moveright and cond.move_right or cond.none
        ---@type Rule
        local rule = Rule(...):with_move(move_func()):with_pair(cond.not_add_quote_inside_quote())

        if #opt.ignored_next_char > 1 then
            rule:with_pair(cond.not_after_regex(opt.ignored_next_char))
        end

        rule:use_undo(opt.break_undo)
        return rule
    end
    return quote
end

local quote = quote_creator(npairs.config)

--+- Custom Rules: Rust -------------------------------------+
npairs.add_rules({
    Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(opts)
        return opts.char == ">"
    end),
})
--+- Custom Rules: Vue --------------------------------------+
npairs.add_rules({
    Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),
})

--+- Custom Rules: Markdown ---------------------------------+
local markdown_ft = { "markdown", "codecompanion", "vimwiki", "rmarkdown", "rmd", "pandoc", "quarto" }

-- Condition: Check if inside code fence ("```")
local function not_inside_code_block()
    return function(opts)
        -- Get current buffer and cursor position
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line = cursor_pos[1] - 1 -- 0-based line number

        -- Get lines up to (but not including) the current line
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, current_line, false)
        local inside_block = false

        -- Track the state of code blocks
        for _, line in ipairs(lines) do
            if line:match("^```") then
                inside_block = not inside_block
            end
        end

        -- If we're inside a block, don't add a new pair
        return not inside_block
    end
end

npairs.remove_rule("*")
npairs.remove_rule("**")
-- Remove: Default code fence rules
npairs.remove_rule("```")
npairs.remove_rule("```.*$")
-- Remove: Default quote rule
npairs.remove_rule("`")
-- Re-add: Default quote rule (excluding markdown)
npairs.add_rule(quote("`", "`"):with_pair(cond.not_filetypes(markdown_ft)))

-- Add markdown asterisk rules

-- Helper function to check if we're at the start of a line (for bullet points)
local function at_start_of_line(opts)
    local col = opts.col
    local line = opts.line
    -- Check if everything before cursor is just whitespace
    local before_cursor = line:sub(1, col - 1)
    return before_cursor:match("^%s*$") ~= nil
end

-- Rule 1: Special handling for typing * when already inside *|*
npairs.add_rule(Rule("*", "**", { "markdown" }):with_pair(function(opts)
    local line = opts.line
    local col = opts.col

    -- Don't expand at start of line (bullet points)
    if at_start_of_line(opts) then
        return false
    end

    local inside_italic = col > 1 and line:sub(col - 1, col - 1) == "*" and opts.next_char == "*"

    if inside_italic then
        -- Delete the closing * that's already there
        vim.schedule(function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Del>", true, false, true), "n", false)
        end)
        return true
    end
    return false
end):with_move(cond.none()))

-- Rule 2: Regular rule for single *
npairs.add_rule(Rule("*", "*", { "markdown" }):with_pair(function(opts)
    local line = opts.line
    local col = opts.col

    -- Don't expand at start of line (bullet points)
    if at_start_of_line(opts) then
        return false
    end

    -- Don't add pair after word character
    if col > 0 and line:sub(col, col):match("%w") then
        return false
    end

    -- Don't add pair if previous char is * (let the special rule handle it)
    if col > 1 and line:sub(col - 1, col - 1) == "*" then
        return false
    end

    return true
end):with_move(function(opts)
    -- Don't move at start of line
    if at_start_of_line(opts) then
        return false
    end

    -- Move past * when it's next
    if opts.next_char == "*" then
        -- But not if we're completing bold
        local col = opts.col
        local line = opts.line
        if col > 1 and line:sub(col - 1, col - 1) == "*" then
            return false
        end
        return true
    end
    return false
end))

-- Rule 3: Rule for ** bold markers
npairs.add_rule(Rule("**", "**", { "markdown" }):with_pair(function(opts)
    local line = opts.line
    local col = opts.col

    -- Don't expand at start of line (bullet points)
    if at_start_of_line(opts) then
        return false
    end

    -- Don't add pair after word character
    if col > 0 and line:sub(col, col):match("%w") then
        return false
    end

    -- Check if there's already a * after the cursor (from italic rule)
    if opts.next_char == "*" then
        return false
    end

    return true
end):with_move(function(opts)
    local col = opts.col
    local line = opts.line

    -- Don't move at start of line
    if at_start_of_line(opts) then
        return false
    end

    -- If next chars are **, move past them
    if opts.next_char == "*" and col < #line and line:sub(col + 1, col + 1) == "*" then
        return true
    end
    return false
end))

npairs.add_rules({
    -- stylua: ignore start
    -- Custom rule for underscore in markdown
    Rule("_", "_", { "markdown" })
        :with_pair(cond.before_regex("%s"))
        :with_pair(ts_conds.is_not_ts_node("inline_formula")),
    Rule("_", "_", { "markdown" })
        :with_pair(cond.before_regex("%s"))
        :with_pair(ts_conds.is_not_ts_node("inline_formula")),
    Rule("```", "```", markdown_ft)
        :with_pair(cond.not_before_char("`", 3))
        :with_pair(not_inside_code_block()),
    Rule("```.*$", "```", markdown_ft):only_cr():use_regex(true),
    quote("`", "`", markdown_ft)
        :with_pair(not_inside_code_block()),
    -- stylua: ignore end
})

--+- Custom Rules: Latex ------------------------------------+
npairs.add_rules({
    -- stylua: ignore start
    Rule("$", "$", { "markdown" })
        :with_pair(cond.not_before_char("$", 1))
        :with_move(function(opts) return opts.char=="$" end),
    Rule("\\[", "\\]", { "markdown" })
        :set_end_pair_length(2),
    -- stylua: ignore end
})
