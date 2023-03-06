return {
    "Olical/conjure",
    keys = "<localleader>r",
    dependencies = {
        {
            "PaterJason/cmp-conjure",
            config = function()
                local cmp = require("cmp")
                local config = cmp.get_config()
                table.insert(config.sources, {
                    name = "buffer",
                    option = {
                        sources = {
                            { name = "conjure" },
                        },
                    },
                })
                cmp.setup(config)
            end,
        },
    },
    init = function()
        vim.g["conjure#mapping#prefix"] = "<localleader>r"
        require("quitlox.util.which_key").register({
            ["<localleader>"] = {
                r = {
                    name = "REPL",
                    l = {
                        name = "REPL Log",
                        s = "Log Split",
                        v = "Log Vertical split",
                        t = "Log Tab",
                        b = "Log Buffer",
                        g = "Log toggle",
                        r = "Log Reset soft",
                        R = "Log Reset hard",
                        l = "Log jump Latest",
                        q = "Log close visible",
                    },
                    e = {
                        name = "REPL Eval",
                        e = "Eval",
                        c = {
                            name = "Eval and Comment",
                            e = "Eval and Comment",
                            r = "Eval Root and Comment",
                            w = "Eval Word and Comment",
                        },
                        w = "Eval Word",
                        ["!"] = "Eval and replace",
                        m = "Eval Mark",
                        f = "Eval File from disk",
                        b = "Eval buffer",
                        E = "Eval visual",
                    },
                    g = {
                        name = "REPL Go",
                        d = "Go Definition",
                    },
                },
            },
        })
    end,
}
