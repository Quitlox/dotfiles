return {
    "nvim-neotest/neotest",
    version = "",
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
        require("which-key").register({
            ["[T"] = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Previous Failed Test" },
            ["]T"] = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Next Failed Test" },
            ["[t"] = { "<cmd>lua require('neotest').jump.prev()<cr>", "Previous Test" },
            ["]t"] = { "<cmd>lua require('neotest').jump.next()<cr>", "Next Test" },
        })

        require("which-key").register({
            name = "Test",
            r = { "<cmd>lua require('neotest').run.run()<cr>", "Test Run" },
            d = { "<cmd>lua require('neotest').run.run({strategy='dap'})<cr>", "Test Debug" },
            f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Test File" },
            x = { "<cmd>lua require('neotest').run.stop()<cr>", "Test Stop" },
            a = { "<cmd>lua require('neotest').run.attach()<cr>", "Test Attach" },
            o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Test Output" },
            s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary toggle" },
        }, { prefix = "<localleader>t" })
    end,
}
