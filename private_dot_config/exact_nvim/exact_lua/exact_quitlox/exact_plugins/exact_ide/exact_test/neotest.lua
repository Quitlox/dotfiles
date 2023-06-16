return {
    -- dir = "~/Workspace/contrib/neotest",
    "nvim-neotest/neotest",
    version = "",
    dependencies = { "antoinemadec/FixCursorHold.nvim", "nvim-neotest/neotest-python" },
    lazy = false,
    keys = {
        "[T",
        "]T",
        "[t",
        "]t",
        "<localleader>tr",
        "<localleader>td",
        "<localleader>tf",
        "<localleader>tx",
        "<localleader>ta",
        "<localleader>to",
        "<localleader>ts",
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            log_level = "trace",
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
            },
            window = {
                mappings = {},
            },
            summary = {
                mappings = {
                    stop = "x",
                    jumpto = { "i", "<cr>" },
                },
            },
            quickfix = {
                enabled = false,
            },
        })

        -- Add autocommand for buffers with filetype "neotest-summary"
        local neotestGroup = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = neotestGroup,
            pattern = { "neotest-summary", "neotest-outline" },
            callback = function() vim.keymap.set("n", "q", neotest.summary.close, {}) end,
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
            l = {
                t = { "<cmd>lua require('neotest').summary.open()<cr>", "Locate Test" },
            }
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
