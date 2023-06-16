return {
    "windwp/nvim-autopairs",
    config = function()
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        local cond = require("nvim-autopairs.conds")

        npairs.setup()
        -- FIXME: Remove once contribution merged
        npairs.add_rules({
            Rule("<", ">", { "rust" })
                :with_pair(cond.before_regex("%a+"))
                :with_move(function(opts) return opts.char == ">" end),
        })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
}
