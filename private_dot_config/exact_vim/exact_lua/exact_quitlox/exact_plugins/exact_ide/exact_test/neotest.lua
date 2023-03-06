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
        require("quitlox.util.which_key").register({
            ["[T"] = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Previous Failed Test" },
            ["]T"] = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Next Failed Test" },
            ["[t"] = { "<cmd>lua require('neotest').jump.prev()<cr>", "Previous Test" },
            ["]t"] = { "<cmd>lua require('neotest').jump.next()<cr>", "Next Test" },
        })

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
