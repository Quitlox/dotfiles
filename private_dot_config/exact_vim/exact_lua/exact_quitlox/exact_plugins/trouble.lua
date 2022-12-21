import(
    "trouble",
    function(trouble)
        trouble.setup({
            action_keys = {
                close = "q",
                open_split = { "<c-v>" },
                open_vsplit = { "<c-b>" },
                toggle_fold = { "zA", "za", "o" },
            },
        })
    end
)

import(
    "which-key",
    function(wk)
        wk.register({
            ["<leader>"] = {
                o = {
                    name = "Diagnostics",
                    d = {
                        name = "Open",
                        x = { "<cmd>TroubleToggle<cr>", "Open Trouble" },
                        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Open Diagnostics Document " },
                        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Open Diagnostics Workspace " },
                        q = { "<cmd>TroubleToggle quickfix_diagnostics<cr>", "Open Quickfix" },
                        n = {"<cmd>TodoTrouble<cr>", "Open Notes"}
                    },
                },
            },
        }, { noremap = true })
    end
)
