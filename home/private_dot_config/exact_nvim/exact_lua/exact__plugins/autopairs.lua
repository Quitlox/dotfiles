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
-- | General Rules             |
-- +---------------------------+
-- Auto-center upon opening brackets
npairs.get_rule("{"):replace_map_cr(function()
    local res = "<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>"
    local line = vim.fn.winline()
    local height = vim.api.nvim_win_get_height(0)
    -- Check if current line is within [1/3, 2/3] of the screen height.
    -- If not, center the current line.
    if line < height / 3 or height * 2 / 3 < line then
        -- Here, 'x' is a placeholder to make sure the indentation doesn't break.
        res = res .. "x<ESC>zzs"
    end
    return res
end)

-- Move past punctuation
for _, punct in pairs({ ",", ";" }) do
    npairs.add_rules({
        Rule("", punct)
            :with_move(function(opts) return opts.char == punct end)
            :with_pair(function() return false end)
            :with_del(function() return false end)
            :with_cr(function() return false end)
            :use_key(punct),
    })
end

-- Mirror spaces inside brackets
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
npairs.add_rules({
    -- Rule for a pair with left-side ' ' and right side ' '
    Rule(" ", " ")
        -- Pair will only occur if the conditional function returns true
        :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
            }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
        -- We only want to delete the pair of spaces when the cursor is as such: ( | )
        :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
        end),
})

-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
    npairs.add_rules({
        -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type

        Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_) return "<C-c>2xi<CR><C-c>O" end),
    })
end

-- +---------------------------+
-- | Javascript Rules          |
-- +---------------------------+
-- Open arrow function (=> {})
npairs.add_rule(
    Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript' })
        :use_regex(true) 
        :set_end_pair_length(2)
)

-- +---------------------------+
-- | Lua Rules                 |
-- +---------------------------+
-- Add trailing commas in lua
npairs.add_rules({
    Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
    Rule("'", "',", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
    Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
})

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
local markdown_ft_not_cc = { "markdown", "vimwiki", "rmarkdown", "rmd", "pandoc", "quarto" }

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
npairs.remove_rule("*")
npairs.add_rule(
    Rule("```.*$", "```", markdown_ft)
        :only_cr()
        :use_regex(true)
)

-- Underscore rule
npairs.add_rule(
    Rule("_", "_", markdown_ft_not_cc)
        :with_pair(ts_conds.is_not_ts_node("inline_formula")) -- Don't pair inside LaTeX inline formulas
        :with_pair(cond.not_before_regex([[%w]], 1)) -- Don't expand after non-whitespace
        :with_pair(cond.not_before_text("`")) -- Don't expand after non-whitespace
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
