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
        if vim.bo[buf].ft == "neo-tree" and vim.b[buf].neo_tree_source == "filesystem" then
            return true
        end
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
require("dap").listeners.after.event_initialized["dapui_config"] = on_open
require("dap").listeners.before.event_terminated["dapui_config"] = on_close
require("dap").listeners.before.event_exited["dapui_config"] = on_close

-- Keymap helper: Evaluate expression
local evaluate = function()
    vim.ui.input({ prompt = "Expression to evaluate: " }, function(input)
        require("dapui").eval(input)
    end)
end

-- Keymaps
vim.keymap.set("n", "<leader>do", function()
    require("dapui").open()
end, { noremap = true, silent = true, desc = "Debug UI Open" })
vim.keymap.set("n", "<leader>dc", function()
    require("dapui").close()
end, { noremap = true, silent = true, desc = "Debug UI Close" })
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
