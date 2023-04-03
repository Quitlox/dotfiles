----------------------------------------------------------------------
--                       DAP: User Interface                        --
----------------------------------------------------------------------
-- We use dapui to provide a friendly user interface for debugging.

-- State
local nvim_tree_enabled = false

-- Logic
local function on_open()
    -- Remember whether the explorer was open
    nvim_tree_enabled = require("nvim-tree.view").is_visible()
    -- Close the explorer
    require("nvim-tree.api").tree.close()
    -- Detach gitsigns
    require("gitsigns").toggle_signs(false)
    -- Open the DAP UI
    require("dapui").open()
end

local function on_close()
    if nvim_tree_enabled then require("nvim-tree.api").tree.open() end
    require("dapui").close()
    require("gitsigns").toggle_signs(true)
end

-- Command: Evaluate single expression
local evaluate = function()
    vim.ui.input({ prompt = "Expression to evaluate: " }, function(input) require("dapui").eval(input) end)
end

return {
    "rcarriga/nvim-dap-ui",
    version = "",
    config = function()
        local dap = require("dap")
        require("dapui").setup({ expand_lines = vim.fn.has("nvim-0.7") == 1 })

        -- Autmatically open/close DAP UI and Nvim-Tree
        dap.listeners.after.event_initialized["dapui_config"] = on_open
        dap.listeners.before.event_terminated["dapui_config"] = on_close
        dap.listeners.before.event_exited["dapui_config"] = on_close

        -- Signs
        vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "ErrorMsg", linehl = "", numhl = "" })
    end,

    -- Triggers
    cmd = { "DapStepOver", "DapStepOut", "DapStepIn", "DapToggleRepl", "DapToggleBreakpoint" },
    keys = { "<localleader>d" },

    -- Keybindings
    init = function()
        require("quitlox.util.which_key").register({
            ["<F8>"] = "<cmd>DapStepOver<cr>",
            ["<S-F8>"] = "<cmd>DapStepOut<cr>",
            ["<F7>"] = "<cmd>DapStepIn<cr>",
            ["<localleader>"] = {
                d = {
                    name = "Debug",
                    o = { "<cmd>lua require('dapui').open()<cr>", "Debug UI Open" },
                    c = { "<cmd>lua require('dapui').close()<cr>", "Debug UI Close" },
                    e = { evaluate, "Evaluate Expression" },
                    d = { "<cmd>lua require('dap').continue()<cr>", "Debugger Launch/Continue" },
                    r = { "<cmd>DapToggleRepl<cr>", "Open REPL" },
                    s = {
                        name = "Step",
                        o = { "<cmd>DapStepOver<cr>", "Step Over (F8)" },
                        u = { "<cmd>DapStepOut<cr>", "Step Out (Shift+F8)" },
                        i = { "<cmd>DapStepIn<cr>", "Step Into (F7)" },
                    },
                    t = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Breakpoint Toggle" },
                    b = {
                        name = "Breakpoint",
                        c = {
                            '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
                            "Breakpoint Condition",
                        },
                        m = {
                            '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
                            "Breakpoint Message",
                        },
                    },
                    l = {
                        name = "List",
                        c = { "<cmd>Telescope dap commands<cr>", "List Debug Commands" },
                        d = { "<cmd>Telescope dap configurations<cr>", "List Debug Configurations" },
                        b = { "<cmd>Telescope dap list_breakpoints<cr>", "List Debug Breakpoints" },
                        v = { "<cmd>Telescope dap variables<cr>", "List Debug Variables" },
                        f = { "<cmd>Telescope dap frames<cr>", "List Debug Frames" },
                    },
                },
            },
        })
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
}
