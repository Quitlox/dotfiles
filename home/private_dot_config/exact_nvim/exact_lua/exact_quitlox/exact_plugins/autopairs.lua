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
npairs.add_rules({
    -- stylua: ignore start
    Rule("*", "*", { "markdown" })
        :with_pair(cond.not_before_regex("\n"))
        :with_pair(ts_conds.is_not_ts_node("inline_formula")), -- not in tex formula
    Rule("_", "_", { "markdown" })
        :with_pair(cond.before_regex("%s"))
        :with_pair(ts_conds.is_not_ts_node("inline_formula")),
    -- stylua: ignore end
    Rule("```", "```", { "codecompanion" }):with_pair(cond.not_before_char("`", 3)),
    Rule("```.*$", "```", { "codecompanion" }):only_cr():use_regex(true),
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
