return {
    "nvim-neotest/neotest",
    dependencies = { "antoinemadec/FixCursorHold.nvim", "nvim-neotest/neotest-python" },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
            },
        })
    end,
    init = function()
        vim.api.nvim_set_keymap(
            "n",
            "[n",
            '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>',
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "n",
            "]n",
            '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>',
            { noremap = true, silent = true }
        )

        require("which-key").register({
            name = "Test",
            r = {
                name = "Test Run",
                t = { "<cmd>lua require('neotest').run.run()<cr>", "Test Runnner closest" },
                d = { "<cmd>lua require('neotest').run.run({strategy='dap'})<cr>", "Test Runner Debug closest" },
                f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Test Runner File" },
                s = { "<cmd>lua require('neotest').run.stop()<cr>", "Test Runner Stop closest" },
                a = { "<cmd>lua require('neotest').run.attach()<cr>", "Test Runner Attach closest" },
            },

            o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Test Output" },
            s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary toggle" },
        }, { prefix = "<localleader>t" })
    end,
}
