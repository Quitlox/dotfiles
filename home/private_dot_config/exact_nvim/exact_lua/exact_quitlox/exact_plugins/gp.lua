-- +---------------------------------------------------------+
-- | robitx/gp.nvim: ChatGPT                                 |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("gp").setup({
    chat_confirm_delete = false,
    toggle_target = "popup",
    chat_user_prefix = "󰭹 :",
    chat_assistant_prefix = { "󰚩 :", "[{{agent}}]" },
    providers = {
        openai = {
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = os.getenv("OPENAI_API_KEY"),
        },
        anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
        },
    },
})

--+- Helper: Change settings during writing -----------------+
local function create_gp_command(command_name, gp_command)
    vim.api.nvim_create_user_command(command_name, function(cmd)
        local prev_matchup_matchparen_fallback = vim.b.matchup_matchparen_fallback
        local prev_matchup_matchparen_enabled = vim.b.matchup_matchparen_enabled
        local prev_foldenable = vim.wo.foldenable

        vim.b.matchup_matchparen_fallback = 0
        vim.b.matchup_matchparen_enabled = 0
        vim.wo.foldenable = false

        vim.api.nvim_create_autocmd("User", {
            pattern = "GpDone",
            group = vim.api.nvim_create_augroup("MyGpDone", { clear = true }),
            once = true,
            desc = "Temporary autocommand to restore previous settings.",
            callback = function()
                vim.b.matchup_matchparen_fallback = prev_matchup_matchparen_fallback
                vim.b.matchup_matchparen_enabled = prev_matchup_matchparen_enabled
                vim.wo.foldenable = prev_foldenable
            end,
        })

        vim.api.nvim_cmd({
            cmd = gp_command,
            range = { cmd.line1, cmd.line2 },
            bang = cmd.bang,
            nargs = cmd.nargs,
            mods = cmd.smods,
        }, {})
    end, { range = true })
end

create_gp_command("MyGpRewrite", "GpRewrite")
create_gp_command("MyGpAppend", "GpAppend")
create_gp_command("MyGpPrepend", "GpPrepend")
create_gp_command("MyGpImplement", "GpImplement")

--+- Keymaps ------------------------------------------------+
vim.keymap.set({ "n", "i" }, "<C-g><C-g>", ":GpChatRespond<cr>", { desc = "Respond", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>f", ":GpChatFinder<cr>", { desc = "ChatFinder", noremap = true, silent = true, nowait = true })

vim.keymap.set({ "n", "i" }, "<C-g>t", ":GpChatToggle<cr>", { desc = "ToggleChat", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>c", ":GpChatNew popup<cr>", { desc = "NewChat", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>v", ":GpChatNew split<cr>", { desc = "NewChat vsplit", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>b", ":GpChatNew vsplit<cr>", { desc = "NewChat split", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g><Tab>", ":GpChatNew tabnew<cr>", { desc = "NewChat tabnew", noremap = true, silent = true, nowait = true })

vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", { desc = "VisualToggleChat", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew popup<cr>", { desc = "VisualChatNew", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>v", ":<C-u>'<,'>GpChatNew split<cr>", { desc = "VisualChatNew split", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpChatNew vsplit<cr>", { desc = "VisualChatNew vsplit", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g><Tab>", ":<C-u>'<,'>GpChatNew tabnew<cr>", { desc = "VisualChatNew tabnew", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", { desc = "VisualChatPaste", noremap = true, silent = true, nowait = true })

-- Prompt Commands
vim.keymap.set({ "n", "i" }, "<C-g>r", ":MyGpRewrite<cr>", { desc = "InlineRewrite", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>a", ":MyGpAppend<cr>", { desc = "Append", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>A", ":MyGpPrepend<cr>", { desc = "Prepend", noremap = true, silent = true, nowait = true })

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>MyGpRewrite<cr>", { desc = "VisualInlineRewrite", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>MyGpAppend<cr>", { desc = "VisualAppend", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>A", ":<C-u>'<,'>MyGpPrepend<cr>", { desc = "VisualPrepend", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>MyGpImplement<cr>", { desc = "VisualImplement", noremap = true, silent = true, nowait = true })

-- vim.keymap.set({"n", "i"}, "<C-g>x", ":GpContext<cr>", { desc = "ToggleContext", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>x", ":GpContext<cr>", { desc = "VisualToggleContext", noremap = true, silent = true, nowait = true })

vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>x", ":GpStop<cr>", { desc = "Stop", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", ":GpNextAgent<cr>", { desc = "NextAgent", noremap = true, silent = true, nowait = true })
