vim.api.nvim_create_user_command("OverseerRestartLast", function()
    local overseer = require("overseer")
    local tasks = overseer.list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], "restart")
    end
end, { desc = "Overseer Restart Last" })

return {
    {
        "stevearc/overseer.nvim",
        version = "",
        lazy = false, -- Overseer lazy loads itself
        keys = {
            { "<leader>eo", "<cmd>OverseerOpen<cr>", desc = "Executor Open" },
            { "<leader>ep", "<cmd>OverseerQuickAction open float<cr>", desc = "Executor Quick Peek" },
            { "<leader>ec", "<cmd>OverseerClose<cr>", desc = "Executor Close" },
            { "<leader>et", "<cmd>OverseerToggle<cr>", desc = "Executor Toggle" },
            { "<leader>er", "<cmd>OverseerRun<cr>", desc = "Executor Run" },
            { "<leader>ei", "<cmd>OverseerInfo<cr>", desc = "Executor Info" },
            { "<leader>em", "<cmd>OverseerBuild<cr>", desc = "Executor Build" },
            { "<leader>eq", "<cmd>OverseerQuickAction<cr>", desc = "Executor Quick Action" },
            { "<leader>ea", "<cmd>OverseerTaskAction<cr>", desc = "Executor Task Action" },
            { "<leader>el", "<cmd>OverseerRestartLast<cr>", desc = "Executor Restart Last" },

            { "<leader>ev", "<cmd>OverseerQuickAction open split<cr>", desc = "Executor Quick Split" },
            { "<leader>eb", "<cmd>OverseerQuickAction open vsplit<cr>", desc = "Executor Quick vSplit" },
        },
        opts = {
            strategy = {
                "toggleterm",
                -- direction = "float",
                hidden = true,
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true, nowait = true })
                end,
                open_on_start = false,
            },
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
                },
            },
        },
    },
    require("quitlox.util").whichkey({
        ["<leader>e"] = { name = "Overseer" },
    }),
    require("quitlox.util").legendary({
        { ":OverseerOpen", "Overseer Open" },
        { ":OverseerClose", "Overseer Close" },
        { ":OverseerToggle", "Overseer Toggle" },
        { ":OverseerSaveBundle", "Overseer Save Bundle" },
        { ":OverseerLoadBundle~", "Overseer Load Bundle" },
        { ":OverseerDeleteBundle", "Overseer Delete Bundle" }, -- FIXME: Not working
        { ":OverseerRun", "Overseer Run" },
        { ":OverseerInfo", "Overseer Info" },
        { ":OverseerBuild", "Overseer Build" },
        { ":OverseerQuickAction", "Overseer Quick Action" },
        { ":OverseerTaskAction", "Overseer Task Action" },
        { ":OverseerClearCache", "Overseer Clear Cache" },

        { ":OverseerRestartLast", "Overseer Restart Last" },
    }),
}
