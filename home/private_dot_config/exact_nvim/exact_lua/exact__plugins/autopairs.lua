-- +---------------------------------------------------------+
-- | windwp/nvim-autopairs: Autopairs                        |
-- +---------------------------------------------------------+

local npairs = require("nvim-autopairs")
npairs.setup({
    disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
})

local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")

-- +---------------------------+
-- | Quote Helper              |
-- +---------------------------+

--- Creates a quote rule with standard autopairs behavior.
--- - Handles quote pairing with move right functionality
--- - Prevents adding quotes inside existing quotes
--- - Copied from nvim-autopairs/rules/basic.lua
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

-- stylua: ignore start

-- +---------------------------+
-- | Rust Rules                |
-- +---------------------------+
npairs.add_rule(
    Rule("<", ">", { "rust" })
        :with_pair(cond.before_regex("%a+:?:?$", 3))
        :with_move(cond.after_text(">"))
)

-- +---------------------------+
-- | Vue Rules                 |
-- +---------------------------+
npairs.add_rule(
    Rule("{{", "  }", "vue")
        :set_end_pair_length(2)
        :with_pair(ts_conds.is_ts_node("text"))
)

-- +---------------------------+
-- | Markdown Rules            |
-- +---------------------------+
local markdown_ft = { "markdown", "codecompanion", "vimwiki", "rmarkdown", "rmd", "pandoc", "quarto" }

-- Remove default asteriks rules (don't exist currently I think)
npairs.remove_rule("*")
npairs.remove_rule("**")

-- Markdown single asteriks rule
npairs.add_rule(
    Rule("*", "*", markdown_ft)
        :with_pair(cond.not_before_regex("^%s*$", -1)) -- Don't expand at start of line (bullet points)
        -- :with_pair(cond.not_after_text("*")) -- Don't open a pair directly next to an existing pair (i.e. "*test**|" (do not expand))
        :with_move(cond.after_text("*")) -- Always move through asteriks (takes care of moving through double asteriks as well)
)

-- Markdown double asteriks rule
npairs.add_rule(
    Rule("**", "**", markdown_ft)
       :replace_endpair(function(opts)
            -- Since the single asteriks rule doesn't trigger at the start of
            -- the line (because that would be a bullet point), we have no
            -- overlap and use our actual ending pair.
            local start_of_line = cond.before_regex([[^%s*$]], -1)(opts)
            if start_of_line then
                return "**"
            end
            -- Due to overlap with the single asterics rule, we only append
            -- a single "extra" asteriks by default
            return "*"
        end)
        :with_pair(cond.not_before_regex([[%w\*]], 2)) -- Don't expand previous pair (i.e. don't expand "**test**|")
        :with_move(cond.none()) -- Don't move for **, let single * rule handle character-by-character movement
)

-- Disable default backtick rule for markdown
npairs.remove_rule("`")
npairs.add_rule(
    quote("`", "`")
        :with_pair(cond.not_filetypes(markdown_ft))
        :with_pair(cond.not_before_regex([[%w]], 1)) -- Don't expand after non-whitespace
)

-- Markdown single backtick rule
-- NOTE: I have configured vimtex to load on markdown files. By default, vimtex
-- loads insert mode mappings starting with backticks, which have been disabled
-- for compatibility with markdown backticks.
npairs.add_rule(
    quote("`", "`", markdown_ft)
        :with_pair(cond.not_before_regex([[%w]], 1)) -- Don't expand after non-whitespace
)

-- Markdown code fence rules
npairs.remove_rule("```")
npairs.remove_rule("```.*$")
npairs.add_rule(
    Rule("```", "```", markdown_ft)
        :with_pair(cond.not_before_char("`", 3))
        :with_pair(ts_conds.is_not_ts_node({"code_fence_content"}))
)
npairs.add_rule(
    Rule("```.*$", "```", markdown_ft)
        :only_cr()
        :use_regex(true)
)

-- Underscore rule
npairs.add_rule(
    Rule("_", "_", markdown_ft)
        :with_pair(ts_conds.is_not_ts_node("inline_formula")) -- Don't pair inside LaTeX inline formulas
        :with_pair(cond.not_before_regex([[%w]], 1)) -- Don't expand after non-whitespace
        :with_move(cond.after_text("_")) -- Move past _ when next char is _
)

-- +---------------------------+
-- | LaTeX Rules (Markdown)    |
-- +---------------------------+
npairs.add_rule(
    Rule("$", "$", { "markdown" })
        :with_pair(cond.not_before_char("$", 1))
        :with_move(cond.after_text("$")) -- Move past $ when next char is $
)
npairs.add_rule(
    Rule("\\[", "\\]", { "markdown" })
        :set_end_pair_length(2)
)

-- stylua: ignore end
