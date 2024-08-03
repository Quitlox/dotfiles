-- +---------------------------------------------------------+
-- | windwp/nvim-autopairs: Autopairs                        |
-- +---------------------------------------------------------+

local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local npairs = require("nvim-autopairs")
local ts_conds = require("nvim-autopairs.ts-conds")

--+- Setup --------------------------------------------------+
npairs.setup()

--+- Custom Rules: Rust -------------------------------------+
npairs.add_rules({
    Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+")):with_move(function(opts) return opts.char == ">" end),
})
--+- Custom Rules: Vue --------------------------------------+
npairs.add_rules({
    Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),
})

--+- Integration with nvim-cmp ------------------------------+
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
