-- +---------------------------------------------------------+
-- | stevearc/overseer.nvim: Runner                          |
-- +---------------------------------------------------------+

local function stop_all()
    local tasks = require("overseer").list_tasks()
    for _, task in ipairs(tasks) do
        require("overseer").run_action(task, "stop")
    end
end

local function restart_all()
    local tasks = require("overseer").list_tasks()
    for _, task in ipairs(tasks) do
        require("overseer").run_action(task, "restart")
    end
end

local function dispose_all()
    local tasks = require("overseer").list_tasks()
    for _, task in ipairs(tasks) do
        require("overseer").run_action(task, "dispose")
    end
end

local function start_all()
    local tasks = require("overseer").list_tasks()
    for _, task in ipairs(tasks) do
        require("overseer").run_action(task, "start")
    end
end

local function open_output(direction)
    local tasks = require("overseer").list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        require("overseer").run_action(tasks[1], "open " .. direction)
    end
end

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "Overseer*",
    callback = function()
        pcall(vim.keymap.del, "n", "ds")
    end,
})

--+- Setup --------------------------------------------------+
require("overseer").setup({
    ---@diagnostic disable-next-line: assign-type-mismatch
    -- strategy = {
    --     "snacks_terminal",
    -- },
    task_list = {
        keymaps = {
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["<A-k>"] = "keymap.scroll_output_up",
            ["<A-j>"] = "keymap.scroll_output_down",
            ["<Esc>"] = "<cmd>close<cr>",
            ["o"] = "keymap.open",
            ["d"] = { "keymap.run_action", opts = { action = "dispose" } },
            ["s"] = { "keymap.run_action", opts = { action = "start" } },
            ["r"] = { "keymap.run_action", opts = { action = "restart" } },
            ["x"] = { "keymap.run_action", opts = { action = "stop" } },
            ["j"] = "keymap.next_task",
            ["k"] = "keymap.prev_task",
            ["X"] = stop_all,
            ["R"] = restart_all,
            ["D"] = dispose_all,
            ["S"] = start_all,
        },
    },
    component_aliases = {
        default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            -- { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } }, -- Disabled to prevent auto-dispose
        },
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>eo", "<cmd>OverseerOpen<cr>", { noremap = true, silent = true, desc = "Overseer Open" })
vim.keymap.set("n", "<leader>ep", function() open_output("float") end, { noremap = true, silent = true, desc = "Overseer Quick Peek" })
vim.keymap.set("n", "<leader>ec", "<cmd>OverseerClose<cr>", { noremap = true, silent = true, desc = "Overseer Close" })
vim.keymap.set("n", "<leader>et", "<cmd>OverseerToggle<cr>", { noremap = true, silent = true, desc = "Overseer Toggle" })
vim.keymap.set("n", "<leader>er", "<cmd>OverseerRun<cr>", { noremap = true, silent = true, desc = "Overseer Pick and Run Task" })
vim.keymap.set("n", "<leader>ex", "<cmd>OverseerRunCmd<cr>", { noremap = true, silent = true, desc = "Overseer Shell Cmd" })
vim.keymap.set("n", "<leader>eq", "<cmd>OverseerTaskAction<cr>", { noremap = true, silent = true, desc = "Overseer Task Action" })
vim.keymap.set("n", "<leader>ea", "<cmd>OverseerTaskAction<cr>", { noremap = true, silent = true, desc = "Overseer Task Action" })
vim.keymap.set("n", "<leader>el", "<cmd>OverseerRestartLast<cr>", { noremap = true, silent = true, desc = "Overseer Restart Last" })

vim.keymap.set("n", "<leader>ev", function() open_output("hsplit") end, { noremap = true, silent = true, desc = "Overseer Quick Split" })
vim.keymap.set("n", "<leader>eb", function() open_output("vsplit") end, { noremap = true, silent = true, desc = "Overseer Quick vSplit" })
require("which-key").add({ { "<leader>e", group = "Overseer" } })

--+- Commands -----------------------------------------------+
vim.api.nvim_create_user_command("OverseerRestartLast", function()
    local overseer = require("overseer")
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], "restart")
    end
end, { desc = "Overseer Restart Last" })
