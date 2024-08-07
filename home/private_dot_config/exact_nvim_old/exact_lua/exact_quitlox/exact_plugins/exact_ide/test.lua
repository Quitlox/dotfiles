vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Neotest Buffer-local Mappings",
    callback = function(args)
        local buf = args.buf
        require("which-key").add({
            -- stylua: ignore start
            {"[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous Failed Test"},
            {"]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test"},
            {"[t", function() require("neotest").jump.prev() end, desc = "Previous Test"},
            {"]t", function() require("neotest").jump.next() end, desc = "Next Test"},
            -- stylua: ignore end
        }, { buffer = args.buf })
    end,
})

return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = { default = { { "<leader>t", group = "Test" } } },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        keys = {
            -- stylua: ignore start
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test Debug Nearest" },
            { "<leader>tD", function() require("neotest").run.run(vim.fn.getcwd(0), { strategy = "dap" }) end, desc = "Test Debug All" },
            -- stylua: ignore end
        },
    },
    {
        "nvim-neotest/neotest",
        version = "",
        dependencies = { "antoinemadec/FixCursorHold.nvim", "nvim-neotest/nvim-nio" },
        keys = {
            -- stylua: ignore start
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Test Run" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test File" },
            { "<leader>tx", function() require("neotest").run.stop() end, desc = "Test Stop" },
            { "<leader>ta", function() require("neotest").run.attach() end, desc = "Test Attach" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test Output" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test Summary toggle" },
            { "<leader>lt", function() require("neotest").summary.open() end, desc = "Locate Test" },
            -- stylua: ignore end
        },
        config = function(_, opts)
            -- Blatently stolen from
            -- https://github.com/LazyVim/LazyVim/blob/b37616c20385520c2a06faca1a2f8954b015af5d/lua/lazyvim/plugins/extras/test/core.lua
            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config)
                        end
                        adapters[#adapters + 1] = config
                    elseif config ~= false then
                        local adapter = require(name)
                        if type(config) == "table" and not vim.tbl_isempty(config) then
                            local meta = getmetatable(adapter)
                            if adapter.setup then
                                adapter.setup(config)
                            elseif meta and meta.__call then
                                adapter(config)
                            else
                                error("Adapter " .. name .. " does not support setup")
                            end
                        end
                        adapters[#adapters + 1] = adapter
                    end
                end
                opts.adapters = adapters
            end

            require("neotest").setup(opts)
        end,
        opts = {
            log_level = "trace",
            window = {
                mappings = {},
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
                -- open = function()
                --     if require("lazyvim.util").has("trouble.nvim") then
                --         vim.cmd("Trouble quickfix")
                --     else
                --         vim.cmd("copen")
                --     end
                -- end,
            },
        },
    },
}
