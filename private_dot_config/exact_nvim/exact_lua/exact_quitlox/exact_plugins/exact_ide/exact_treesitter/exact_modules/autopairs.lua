return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        local cond = require("nvim-autopairs.conds")

        npairs.setup()

        -- FIXME: Remove once contribution merged
        npairs.add_rules({
            Rule("<", ">", { "rust" }):with_pair(cond.before_regex("%a+")):with_move(function(opts) return opts.char ==
                ">" end),
        })

        ----------------------------------------
        -- Parenthesis after Accept Function Completion
        ----------------------------------------
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
