----------------------------------------------------------------------
--                       DAP: User Interface                        --
----------------------------------------------------------------------
-- We use dapui to provide a friendly user interface for debugging.

-- State
local state = {
    neo_tree_open = false,
    gitsigns_enabled = false,
}

-- Logic
local function on_open()
    -- Close the explorer
    if require("quitlox.util").is_neotree_open() then
        state.neo_tree_open = true
        require("neo-tree.command").execute({ action = "close" })
    end

    require("gitsigns").toggle_signs(false)
    require("dapui").open()
end

local function on_close()
    -- Open the explorer
    if state.neo_tree_open then
        require("neo-tree.command").execute({ action = "open" })
        state.neo_tree_open = false
    end

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
            { "<F9>", function() require("dap").continue() end, desc = "Debug Continue" },
            { "<F8>", function() require("dap").step_over() end, desc = "Debug Step Over" },
            { "<S-F8>", function() require("dap").step_out() end, desc = "Debug Step Out" },
            { "<F7>", function() require("dap").step_into() end, desc = "Debug Step Into" },
            { "<leader>do", function() require("dapui").open() end, desc = "Debug UI Open" },
            { "<leader>dc", function() require("dapui").close() end, desc = "Debug UI Close" },
            { "<leader>de", evaluate, desc = "Evaluate Expression" },
            { "<leader>dd", function() require("dap").continue() end, desc = "Debugger Launch/Continue" },
            { "<leader>dx", function() require("dap").terminate() end, desc = "Debugger Terminate" },
            { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Open REPL" },
            { "<leader>dso", function() require("dap").step_over() end, desc = "Step Over (F8)" },
            { "<leader>dsu", function() require("dap").step_out() end, desc = "Step Out (Shift+F8)" },
            { "<leader>dsi", function() require("dap").step_into() end, desc = "Step Into (F7)" },
            { "<leader>dt", function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Breakpoint Toggle" },
            { "<leader>dbc", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, desc = "Breakpoint Condition" },
            { "<leader>dbm", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Breakpoint Message" },
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
        },
    },
    -- Telescope extension
    {
        "nvim-telescope/telescope-dap.nvim",
        config = function() require("telescope").load_extension("dap") end,
        keys = {
            { "<leader>dlc", function() require("telescope").extensions.dap.commands() end, desc = "List Debug Commands" },
            { "<leader>dld", function() require("telescope").extensions.dap.configurations() end, desc = "List Debug Configurations" },
            { "<leader>dlb", function() require("telescope").extensions.dap.list_breakpoints() end, desc = "List Debug Breakpoints" },
            { "<leader>dlv", function() require("telescope").extensions.dap.variables() end, desc = "List Debug Variables" },
            { "<leader>dlf", function() require("telescope").extensions.dap.frames() end, desc = "List Debug Frames" },
        },
    },
    require("quitlox.util").whichkey({
        ["<leader>d"] = { name = "Debug" },
        ["<leader>ds"] = { name = "Step" },
        ["<leader>db"] = { name = "Breakpoint" },
        ["<leader>dl"] = { name = "List" },
    }),
}
