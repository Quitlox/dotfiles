-- +---------------------------------------------------------+
-- | ofirgall/goto-breakpoints.nvim: Navigate Breakpoints    |
-- +---------------------------------------------------------+
vim.keymap.set("n", "[b", function() require("goto-breakpoints").prev() end, { noremap = true, silent = true, desc = "Previous Breakpoint" })
vim.keymap.set("n", "]b", function() require("goto-breakpoints").next() end, { noremap = true, silent = true, desc = "Next Breakpoint" })

-- +---------------------------------------------------------+
-- | theHamsta/nvim-dap-virtual-text: Virtual Text for DAP   |
-- +---------------------------------------------------------+
require("nvim-dap-virtual-text").setup()

-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap: Debug Adapter Protocol           |
-- +---------------------------------------------------------+

local dap = require("dap")

-- dap.defaults.fallback
dap.defaults.fallback.switchbuf = "useopen,uselast"
-- dap.defaults.fallback.stepping_granularity = "line"

--+- Launch.json --------------------------------------------+
-- Command: Reload launch.json
local function load_launch_json()
    local status, err = pcall(require("dap.ext.vscode").load_launchjs)
    if not status then require("notify")("Is there a typo in the config?\n\n" .. err, "ERROR", { title = "Error while loading .vscode/launch.json" }) end
end

-- Load launch.json on startup
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
    desc = "Load launch.json on startup",
    callback = load_launch_json,
})

-- Load launch.json when edited
local launch_group = vim.api.nvim_create_augroup("LaunchJson", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = launch_group,
    desc = "Reload launch.json on save",
    pattern = "launch.json",
    callback = load_launch_json,
})

vim.api.nvim_create_user_command("LoadLaunchJson", load_launch_json, {
    desc = "Reload launch.json",
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<F9>", function() require("dap").continue() end, { noremap = true, silent = true, desc = "Debug Continue" })
vim.keymap.set("n", "<F8>", function() require("dap").step_over() end, { noremap = true, silent = true, desc = "Debug Step Over" })
vim.keymap.set("n", "<S-F8>", function() require("dap").step_out() end, { noremap = true, silent = true, desc = "Debug Step Out" })
vim.keymap.set("n", "<F7>", function() require("dap").step_into() end, { noremap = true, silent = true, desc = "Debug Step Into" })
vim.keymap.set("n", "<leader>dd", function() require("dap").continue() end, { noremap = true, silent = true, desc = "Debugger Launch/Continue" })
vim.keymap.set("n", "<leader>dx", function() require("dap").terminate() end, { noremap = true, silent = true, desc = "Debugger Terminate" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapToggleRepl<cr>", { noremap = true, silent = true, desc = "Open REPL" })

vim.keymap.set("n", "<leader>dt", function() require("dap").toggle_breakpoint() end, { noremap = true, silent = true, desc = "Breakpoint Toggle" })
vim.keymap.set("n", "<leader>dbm", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { noremap = true, silent = true, desc = "Breakpoint Message" })
vim.keymap.set("n", "<leader>dbc", function() require("dap").toggle_breakpoint(vim.fn.input("Condition: ")) end, { noremap = true, silent = true, desc = "Breakpoint Condition" })

vim.keymap.set("n", "<leader>dv", "<cmd>LoadLaunchJson<cr>", { noremap = true, silent = true, desc = "Reload launch.json" })

-- +---------------------------------------------------------+
-- | rcarriga/nvim-dap-ui: Debug Adapter Protocol UI         |
-- +---------------------------------------------------------+

-- Setup
require("dapui").setup({ expand_lines = true })

-- State
local state = {
    neo_tree_open = false,
    gitsigns_enabled = false,
}

local function is_neotree_open()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].ft == "neo-tree" and vim.b[buf].neo_tree_source == "filesystem" then return true end
    end

    return false
end

-- Logic
local function on_open()
    if is_neotree_open() then
        state.neo_tree_open = true
        require("neo-tree.command").execute({ action = "close" })
    end

    require("gitsigns").toggle_signs(false)
    require("dapui").open()
end

local function on_close()
    if state.neo_tree_open then
        require("neo-tree.command").execute({ action = "open" })
        state.neo_tree_open = false
    end

    require("dapui").close()
    require("gitsigns").toggle_signs(true)
end

-- Autmatically open/close DAP UI and Nvim-Tree
dap.listeners.after.event_initialized["dapui_config"] = on_open
dap.listeners.before.event_terminated["dapui_config"] = on_close
dap.listeners.before.event_exited["dapui_config"] = on_close

-- Keymap helper: Evaluate expression
local evaluate = function()
    vim.ui.input({ prompt = "Expression to evaluate: " }, function(input) require("dapui").eval(input) end)
end

-- Keymaps
vim.keymap.set("n", "<leader>do", function() require("dapui").open() end, { noremap = true, silent = true, desc = "Debug UI Open" })
vim.keymap.set("n", "<leader>dc", function() require("dapui").close() end, { noremap = true, silent = true, desc = "Debug UI Close" })
vim.keymap.set("n", "<leader>de", evaluate, { noremap = true, silent = true, desc = "Evaluate Expression" })

-- Signs (required by Catppuccin)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

require("which-key").add({
    { "<leader>d", group = "Debug" },
    { "<leader>db", group = "Breakpoint" },
    { "<leader>dl", group = "List" },
})
