-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap: Debug Adapter Protocol           |
-- +---------------------------------------------------------+

local dap = require("dap")

-- dap.defaults.fallback
dap.defaults.fallback.switchbuf = "useopen,uselast"

--+- Launch.json --------------------------------------------+
-- Command: Reload launch.json
local function load_launch_json()
    local status, err = pcall(require("dap.ext.vscode").load_launchjs)
    if not status then
        require("notify")("Is there a typo in the config?\n\n" .. err, "ERROR", { title = "Error while loading .vscode/launch.json" })
    end
end

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
-- stylua: ignore start
vim.keymap.set("n", "<F9>", function() require("dap").continue() end, { noremap = true, silent = true, desc = "Debug Continue" })
vim.keymap.set("n", "<S-F9>", function() require("dap").goto_() end, { noremap = true, silent = true, desc = "Debug until Cursor" })
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
-- stylua: ignore end

--+- DAP: Javascript / Typescript ---------------------------+
require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        ---@diagnostic disable-next-line: assign-type-mismatch
        args = { vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "vscode-js-debug"), "${port}" },
    },
}

for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }
end

-- FIXME: To be able to use these configurations again, install the required dependencies.
-- See https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
-- { "microsoft/vscode-js-debug", build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git reset --hard HEAD", version = "v1.*" },

--+- Signs --------------------------------------------------+
-- Signs (required by Catppuccin)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

--+- Workaround ---------------------------------------------+
-- https://github.com/neovim/neovim/issues/14116
-- https://github.com/rcarriga/nvim-dap-ui/issues/31

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
      " Only apply if the filetype is not 'codecompanion'
      if getbufvar(bufnr(), '&filetype') !=# 'codecompanion'
        silent! inoremap <buffer><silent> <backspace> <Cmd>lua PromptBackspace()<cr>
        " Fix <C-BS> in prompt
        silent! inoremap <buffer><silent> <C-BS> <Cmd>normal! bcw<cr>
      endif
    endif
endfun

silent! autocmd OptionSet * call PromptBackspaceSetup() "not using a lua function here because of error when accessing :help
]])
