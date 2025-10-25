-- +---------------------------------------------------------+
-- | rcarriga/nvim-dap-ui: Debug Adapter Protocol UI         |
-- +---------------------------------------------------------+

-- Setup
require("dapui").setup({
    expand_lines = true,
    mappings = {
        remove = "dd",
    },
    element_mappings = {
        stacks = {
            open = { "<cr>", "i", "o" },
        },
    },
}) ---@diagnostic disable-line: missing-fields

-- State
local state = {
    neo_tree_open = false,
}

local function is_neotree_open()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].ft == "neo-tree" and vim.b[buf].neo_tree_source == "filesystem" then
            return true
        end
    end

    return false
end

local function neo_tree_open()
    if state.neo_tree_open then
        require("neo-tree.command").execute({ action = "open" })
        state.neo_tree_open = false
    end
end

local function neo_tree_close()
    if is_neotree_open() then
        state.neo_tree_open = true
        require("neo-tree.command").execute({ action = "close" })
    end
end

-- Logic
local function on_open()
    neo_tree_close()
    require("overseer").close()
    require("gitsigns").toggle_signs(false)
    require("dapui").open()
end

local function on_close()
    neo_tree_open()
    require("dapui").close()
    require("gitsigns").toggle_signs(true)
end

-- Autmatically open/close DAP UI and Nvim-Tree
-- require("dap").listeners.after.event_initialized["dapui_config"] = on_open
-- require("dap").listeners.before.event_terminated["dapui_config"] = on_close
-- require("dap").listeners.before.event_exited["dapui_config"] = on_close

--+- Keymaps ------------------------------------------------+
-- Keymap helper: Evaluate expression
local evaluate = function()
    vim.ui.input({ prompt = "Expression to evaluate: " }, function(input)
        require("dapui").eval(input)
    end)
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>do", function() require("dapui").open() end, { noremap = true, silent = true, desc = "Debug UI Open" })
vim.keymap.set("n", "<leader>dc", function() require("dapui").close() end, { noremap = true, silent = true, desc = "Debug UI Close" })
vim.keymap.set("n", "<leader>de", evaluate, { noremap = true, silent = true, desc = "Evaluate Expression" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>d", group = "Debug" },
    { "<leader>db", group = "Breakpoint" },
    { "<leader>dl", group = "List" },
})

--+- Fix Highlights -----------------------------------------+
-- Fix DAP UI icon highlighting in Edgy windows
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("DapUiFixHighlights", { clear = true }),
    callback = function()
        local winbar_bg = vim.api.nvim_get_hl(0, { name = "EdgyWinBar" }).bg
        if winbar_bg then
            local control_hl_groups = {
                "DapUIPlayPause",
                "DapUIRestart",
                "DapUIStop",
                "DapUIUnavailable",
                "DapUIStepOver",
                "DapUIStepInto",
                "DapUIStepBack",
                "DapUIStepOut",
            }
            for _, hl_group in ipairs(control_hl_groups) do
                local current = vim.api.nvim_get_hl(0, { name = hl_group })
                current.bg = winbar_bg
                vim.api.nvim_set_hl(0, hl_group, current)
            end
        end
    end,
})
