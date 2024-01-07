----------------------------------------------------------------------
--                       DAP: User Interface                        --
----------------------------------------------------------------------
-- We use dapui to provide a friendly user interface for debugging.

-- State
local nvim_tree_enabled = false

-- Logic
local function on_open()
    -- Remember whether the explorer was open
    -- TODO: Replace with NeoTree
    -- Close the explorer
    -- TODO: Replace with NeoTree
    -- Detach gitsigns
    require("gitsigns").toggle_signs(false)
    -- Open the DAP UI
    require("dapui").open()
end

local function on_close()
    -- Open the explorer
    -- TODO: Replace with NeoTree
    require("dapui").close()
    require("gitsigns").toggle_signs(true)
end

-- Command: Evaluate single expression
local evaluate = function()
    vim.ui.input({ prompt = "Expression to evaluate: " }, function(input) require("dapui").eval(input) end)
end

return {
    {
        "rcarriga/nvim-dap-ui",
        version = "",
        config = function()
            local dap = require("dap")
            require("dapui").setup({ expand_lines = true })

            -- Autmatically open/close DAP UI and Nvim-Tree
            dap.listeners.after.event_initialized["dapui_config"] = on_open
            dap.listeners.before.event_terminated["dapui_config"] = on_close
            dap.listeners.before.event_exited["dapui_config"] = on_close
        end,

        -- Triggers
        cmd = { "DapToggleRepl", "DapToggleBreakpoint" },
        keys = {
            { "<F9>", "<cmd>lua require('dap').continue()<cr>", desc = "Debug Continue" },
            { "<F8>", "<cmd>lua require('dap').step_over()<cr>", desc = "Debug Step Over" },
            { "<S-F8>", "<cmd>lua require('dap').step_out()<cr>", desc = "Debug Step Out" },
            { "<F7>", "<cmd>lua require('dap').step_into()<cr>", desc = "Debug Step Into" },
            { "<leader>do", "<cmd>lua require('dapui').open()<cr>", desc = "Debug UI Open" },
            { "<leader>dc", "<cmd>lua require('dapui').close()<cr>", desc = "Debug UI Close" },
            { "<leader>de", evaluate, desc = "Evaluate Expression" },
            { "<leader>dd", "<cmd>lua require('dap').continue()<cr>", desc = "Debugger Launch/Continue" },
            { "<leader>dx", "<cmd>lua require('dap').terminate()<cr>", desc = "Debugger Terminate" },
            { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Open REPL" },
            { "<leader>dso", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over (F8)" },
            { "<leader>dsu", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out (Shift+F8)" },
            { "<leader>dsi", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into (F7)" },
            { "<leader>dt", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Breakpoint Toggle" },
            { "<leader>dbc", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', desc = "Breakpoint Condition" },
            { "<leader>dbm", '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', desc = "Breakpoint Message" },
            { "<leader>dlc", "<cmd>Telescope dap commands<cr>", desc = "List Debug Commands" },
            { "<leader>dld", "<cmd>Telescope dap configurations<cr>", desc = "List Debug Configurations" },
            { "<leader>dlb", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List Debug Breakpoints" },
            { "<leader>dlv", "<cmd>Telescope dap variables<cr>", desc = "List Debug Variables" },
            { "<leader>dlf", "<cmd>Telescope dap frames<cr>", desc = "List Debug Frames" },
        },

        -- Keybindings
        init = function()
            -- Signs (required by Catppuccin)
            local sign = vim.fn.sign_define
            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,

        dependencies = {
            "mfussenegger/nvim-dap",
            -- Virtual Text while debugging
            { "theHamsta/nvim-dap-virtual-text", config = true },
            -- Telescope extension
            {
                "nvim-telescope/telescope-dap.nvim",
                dependencies = { "nvim-telescope/telescope.nvim" },
                config = function() require("telescope").load_extension("dap") end,
            },
        },
    },
    require("quitlox.util").whichkey({
        ["<leader>d"] = { name = "Debug" },
        ["<leader>ds"] = { name = "Step" },
        ["<leader>db"] = { name = "Breakpoint" },
        ["<leader>dl"] = { name = "List" },
    }),
}
