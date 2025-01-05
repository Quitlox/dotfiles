-- +---------------------------------------------------------+
-- | rcarriga/nvim-dap-ui: Debug Adapter Protocol UI         |
-- +---------------------------------------------------------+

-- Setup
require("dapui").setup({ expand_lines = true, mappings = { remove = "dd" } })

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
-- stylua: ignore start
vim.keymap.set("n", "<leader>do", function() require("dapui").open() end, { noremap = true, silent = true, desc = "Debug UI Open" })
vim.keymap.set("n", "<leader>dc", function() require("dapui").close() end, { noremap = true, silent = true, desc = "Debug UI Close" })
vim.keymap.set("n", "<leader>de", evaluate, { noremap = true, silent = true, desc = "Evaluate Expression" })
-- stylua: ignore end

-- Signs (required by Catppuccin)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

require("which-key").add({
    { "<leader>d", group = "Debug" },
    { "<leader>db", group = "Breakpoint" },
    { "<leader>dl", group = "List" },
})

--+- Workaround ---------------------------------------------+
-- https://github.com/neovim/neovim/issues/14116

function PromptBackspace()
    -- Allows backspacing through previously set text when in a prompt.
    --
    -- Note 1: Insert mode cursor is after (+1) the column as opposed to in normal mode it would be on (+0) the column.
    -- Note 2: nvim_win_[get|set]_cursor is (1, 0) indexed for (line, column) while nvim_buf_[get|set]_[lines|text] is 0 indexed for both.

    local currentCursor = vim.api.nvim_win_get_cursor(0)
    local currentLineNumber = currentCursor[1]
    local currentColumnNumber = currentCursor[2]
    local promptLength = vim.str_utfindex(vim.fn["prompt_getprompt"]("%"))

    if currentColumnNumber ~= promptLength then
        vim.api.nvim_buf_set_text(0, currentLineNumber - 1, currentColumnNumber - 1, currentLineNumber - 1, currentColumnNumber, { "" })
        vim.api.nvim_win_set_cursor(0, { currentLineNumber, currentColumnNumber - 1 })
    end
end

vim.cmd([[
fun! PromptBackspaceSetup()
    if v:option_new == 'prompt'
      inoremap <buffer> <backspace> <Cmd>lua PromptBackspace()<cr>
      " Fix <C-BS> in prompt
      inoremap <buffer> <C-BS> <Cmd>normal! bcw<cr>
    endif
endfun

autocmd OptionSet * call PromptBackspaceSetup() "not using a lua function here because of error when accessing :help
]])
