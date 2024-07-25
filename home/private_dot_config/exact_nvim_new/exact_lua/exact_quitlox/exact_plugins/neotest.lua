--+- Setup --------------------------------------------------+
require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = true },
            args = { "--log-level", "DEBUG", "--log-cli-level", "DEBUG", "-v" },
        }),
    },
    summary = {
        mappings = {
            stop = "x",
            jumpto = { "i", "<cr>" },
        },
    },
    floating = {
        max_width = 0.99,
    },
    quickfix = {
        enabled = false,
    },
})

--+- Keymaps ------------------------------------------------+
require("which-key").add({ { "<leader>t", group = "Test" } })
vim.keymap.set("n", "<leader>trr", function() require("neotest").run.run() end, { noremap = true, desc = "Test Run" })
vim.keymap.set("n", "<leader>trf", function() require("neotest").run.run(vim.fn.expand("%")) end, { noremap = true, desc = "Test File" })
vim.keymap.set("n", "<leader>trx", function() require("neotest").run.stop() end, { noremap = true, desc = "Test Stop" })
vim.keymap.set("n", "<leader>tra", function() require("neotest").run.attach() end, { noremap = true, desc = "Test Attach" })
vim.keymap.set("n", "<leader>tro", function() require("neotest").output.open({ enter = true }) end, { noremap = true, desc = "Test Output" })
vim.keymap.set("n", "<leader>trs", function() require("neotest").summary.toggle() end, { noremap = true, desc = "Test Summary toggle" })
vim.keymap.set("n", "<leader>lt", function() require("neotest").summary.open() end, { noremap = true, desc = "Locate Test" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyNeotestKeybindings", { clear = true }),
    desc = "Neotest Buffer Mappings",
    callback = function(args)
        vim.keymap.set("n", "[T", function() require("neotest").jump.prev({ status = "failed" }) end, { buffer = args.buf, noremap = true, desc = "Previous Failed Test" })
        vim.keymap.set("n", "]T", function() require("neotest").jump.next({ status = "failed" }) end, { buffer = args.buf, noremap = true, desc = "Next Failed Test" })
        vim.keymap.set("n", "[t", function() require("neotest").jump.prev() end, { buffer = args.buf, noremap = true, desc = "Previous Test" })
        vim.keymap.set("n", "]t", function() require("neotest").jump.next() end, { buffer = args.buf, noremap = true, desc = "Next Test" })
    end,
})

--+- Integration: DAP ---------------------------------------+
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { noremap = true, desc = "Test Debug Nearest" })
vim.keymap.set("n", "<leader>tD", function() require("neotest").run.run(vim.fn.getcwd(0), { strategy = "dap" }) end, { noremap = true, desc = "Test Debug All" })
