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
    Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+")):with_move(function(opts)
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

-- Remove: Default code fence rules
npairs.remove_rule("```")
npairs.remove_rule("```.*$")
-- Remove: Default quote rule
npairs.remove_rule("`")
-- Readd Default: Quote Rule (excluding markdown)
npairs.add_rule(quote("`", "`"):with_pair(cond.not_filetypes(markdown_ft)))

npairs.add_rules({
    -- stylua: ignore start
    Rule("*", "*", { "markdown" })
        :with_pair(cond.not_before_regex("\n"))
        :with_pair(ts_conds.is_not_ts_node("inline_formula")), -- not in tex formula
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
