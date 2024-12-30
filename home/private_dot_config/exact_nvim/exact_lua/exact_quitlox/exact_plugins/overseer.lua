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

--+- Setup --------------------------------------------------+
require("overseer").setup({
    ---@diagnostic disable-next-line: assign-type-mismatch
    -- strategy = {
    --     "snacks_terminal",
    -- },
    task_list = {
        default_detail = 2,
        bindings = {
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["<A-l>"] = "IncreaseDetail",
            ["<A-h>"] = "DecreaseDetail",
            ["<A-k>"] = "ScrollOutputUp",
            ["<A-j>"] = "ScrollOutputDown",
            ["<Esc>"] = "Close",
            ["o"] = "<cmd>OverseerQuickAction open<cr>",
            ["d"] = "<cmd>OverseerQuickAction dispose<cr>",
            ["s"] = "<cmd>OverseerQuickAction start<cr>",
            ["r"] = "<cmd>OverseerQuickAction restart<cr>",
            ["x"] = "<cmd>OverseerQuickAction stop<cr>",
            ["X"] = stop_all,
            ["R"] = restart_all,
        },
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>eo", "<cmd>OverseerOpen<cr>", { noremap = true, silent = true, desc = "Overseer Open" })
vim.keymap.set("n", "<leader>ep", "<cmd>OverseerQuickAction open float<cr>", { noremap = true, silent = true, desc = "Overseer Quick Peek" })
vim.keymap.set("n", "<leader>ec", "<cmd>OverseerClose<cr>", { noremap = true, silent = true, desc = "Overseer Close" })
vim.keymap.set("n", "<leader>et", "<cmd>OverseerToggle<cr>", { noremap = true, silent = true, desc = "Overseer Toggle" })
vim.keymap.set("n", "<leader>er", "<cmd>OverseerRun<cr>", { noremap = true, silent = true, desc = "Overseer Run" })
vim.keymap.set("n", "<leader>em", "<cmd>OverseerBuild<cr>", { noremap = true, silent = true, desc = "Overseer Build" })
vim.keymap.set("n", "<leader>eq", "<cmd>OverseerQuickAction<cr>", { noremap = true, silent = true, desc = "Overseer Quick Action" })
vim.keymap.set("n", "<leader>ea", "<cmd>OverseerTaskAction<cr>", { noremap = true, silent = true, desc = "Overseer Task Action" })
vim.keymap.set("n", "<leader>el", "<cmd>OverseerRestartLast<cr>", { noremap = true, silent = true, desc = "Overseer Restart Last" })

vim.keymap.set("n", "<leader>ev", "<cmd>OverseerQuickAction open split<cr>", { noremap = true, silent = true, desc = "Overseer Quick Split" })
vim.keymap.set("n", "<leader>eb", "<cmd>OverseerQuickAction open vsplit<cr>", { noremap = true, silent = true, desc = "Overseer Quick vSplit" })
require("which-key").add({ { "<leader>e", "Overseer" } })

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

require("legendary").commands({
    { ":OverseerOpen", description = "Overseer Open" },
    { ":OverseerClose", description = "Overseer Close" },
    { ":OverseerToggle", description = "Overseer Toggle" },
    { ":OverseerSaveBundle", description = "Overseer Save Bundle" },
    { ":OverseerLoadBundle", description = "Overseer Load Bundle" },
    { ":OverseerDeleteBundle", description = "Overseer Delete Bundle" }, -- FIXME: Not working
    { ":OverseerRun", description = "Overseer Run" },
    { ":OverseerInfo", description = "Overseer Info" },
    { ":OverseerBuild", description = "Overseer Build" },
    { ":OverseerQuickAction", description = "Overseer Quick Action" },
    { ":OverseerTaskAction", description = "Overseer Task Action" },
    { ":OverseerClearCache", description = "Overseer Clear Cache" },

    { ":OverseerRestartLast", description = "Overseer Restart Last" },
})
