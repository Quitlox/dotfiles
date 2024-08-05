-- +---------------------------------------------------------+
-- | robitx/gp.nvim: ChatGPT                                 |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("gp").setup({
    chat_confirm_delete = false,
    toggle_target = "popup",
    chat_user_prefix = "󰭹 :",
    chat_assistant_prefix = { "󰚩 :", "[{{agent}}]" },
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
vim.keymap.set({ "n", "i" }, "<C-g>c", ":GpChatNew popup<cr>", { desc = "NewChat", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>t", ":GpChatToggle<cr>", { desc = "ToggleChat", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>f", ":GpChatFinder<cr>", { desc = "ChatFinder", noremap = true, silent = true, nowait = true })

vim.keymap.set("v", "<C-g>c", ":'<,'>GpChatNew<cr>", { desc = "VisualChatNew", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>p", ":'<,'>GpChatPaste<cr>", { desc = "VisualChatPaste", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>t", ":'<,'>GpChatToggle<cr>", { desc = "VisualToggleChat", noremap = true, silent = true, nowait = true })

vim.keymap.set({ "n", "i" }, "<C-g><C-b>", ":GpChatNew vsplit<cr>", { desc = "NewChat split", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", ":GpChatNew split<cr>", { desc = "NewChat vsplit", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g><Tab>", ":GpChatNew tabnew<cr>", { desc = "NewChat tabnew", noremap = true, silent = true, nowait = true })

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", { desc = "VisualChatNew split", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", { desc = "VisualChatNew vsplit", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g><Tab>", ":<C-u>'<,'>GpChatNew tabnew<cr>", { desc = "VisualChatNew tabnew", noremap = true, silent = true, nowait = true })

-- Prompt Commands
vim.keymap.set({ "n", "i" }, "<C-g>r", ":MyGpRewrite<cr>", { desc = "InlineRewrite", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>a", ":MyGpAppend<cr>", { desc = "Append", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i" }, "<C-g>b", ":MyGpPrepend<cr>", { desc = "Prepend", noremap = true, silent = true, nowait = true })

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>MyGpRewrite<cr>", { desc = "VisualInlineRewrite", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>MyGpAppend<cr>", { desc = "VisualAppend", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>MyGpPrepend<cr>", { desc = "VisualPrepend", noremap = true, silent = true, nowait = true })
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>MyGpImplement<cr>", { desc = "VisualImplement", noremap = true, silent = true, nowait = true })

-- vim.keymap.set({"n", "i"}, "<C-g>gp", ":GpPopup<cr>", { desc = "Popup", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>ge", ":GpEnew<cr>", { desc = "GpEnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>gn", ":GpNew<cr>", { desc = "GpNew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>gv", ":GpVnew<cr>", { desc = "GpVnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>gt", ":GpTabnew<cr>", { desc = "GpTabnew", noremap = true, silent = true, nowait = true })

-- vim.keymap.set("v", "<C-g>gp", ":'<,'>GpPopup<cr>", { desc = "VisualPopup", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>ge", ":'<,'>GpEnew<cr>", { desc = "VisualGpEnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>gn", ":'<,'>GpNew<cr>", { desc = "VisualGpNew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>gv", ":'<,'>GpVnew<cr>", { desc = "VisualGpVnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>gt", ":'<,'>GpTabnew<cr>", { desc = "VisualGpTabnew", noremap = true, silent = true, nowait = true })

-- vim.keymap.set({"n", "i"}, "<C-g>x", ":GpContext<cr>", { desc = "ToggleContext", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>x", ":GpContext<cr>", { desc = "VisualToggleContext", noremap = true, silent = true, nowait = true })

vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", ":GpStop<cr>", { desc = "Stop", noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", ":GpAgentNext<cr>", { desc = "NextAgent", noremap = true, silent = true, nowait = true })

-- Optional Whisper Commands
-- vim.keymap.set({"n", "i"}, "<C-g>ww", ":GpWhisper<cr>", { desc = "Whisper", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>ww", ":'<,'>GpWhisper<cr>", { desc = "VisualWhisper", noremap = true, silent = true, nowait = true })

-- vim.keymap.set({"n", "i"}, "<C-g>wr", ":GpWhisperRewrite<cr>", { desc = "WhisperRewrite", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>wa", ":GpWhisperAppend<cr>", { desc = "WhisperAppend", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>wb", ":GpWhisperPrepend<cr>", { desc = "WhisperPrepend", noremap = true, silent = true, nowait = true })

-- vim.keymap.set("v", "<C-g>wr", ":GpWhisperRewrite<cr>", { desc = "VisualWhisperRewrite", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>wa", ":GpWhisperAppend<cr>", { desc = "VisualWhisperAppend", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>wb", ":GpWhisperPrepend<cr>", { desc = "VisualWhisperPrepend", noremap = true, silent = true, nowait = true })

-- vim.keymap.set({"n", "i"}, "<C-g>wp", ":GpWhisperPopup<cr>", { desc = "WhisperPopup", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>we", ":GpWhisperEnew<cr>", { desc = "WhisperEnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>wn", ":GpWhisperNew<cr>", { desc = "WhisperNew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>wv", ":GpWhisperVnew<cr>", { desc = "WhisperVnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set({"n", "i"}, "<C-g>wt", ":GpWhisperTabnew<cr>", { desc = "WhisperTabnew", noremap = true, silent = true, nowait = true })

-- vim.keymap.set("v", "<C-g>wp", ":'<,'>GpWhisperPopup<cr>", { desc = "VisualWhisperPopup", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>we", ":'<,'>GpWhisperEnew<cr>", { desc = "VisualWhisperEnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>wn", ":'<,'>GpWhisperNew<cr>", { desc = "VisualWhisperNew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>wv", ":'<,'>GpWhisperVnew<cr>", { desc = "VisualWhisperVnew", noremap = true, silent = true, nowait = true })
-- vim.keymap.set("v", "<C-g>wt", ":'<,'>GpWhisperTabnew<cr>", { desc = "VisualWhisperTabnew", noremap = true, silent = true, nowait = true })

--+- Commands -----------------------------------------------+
require("legendary").commands({
    --[[ Chat Commands ]]
    { ":GpChatNew popup", description = "Open a fresh chat in a popup window." },
    { ":GpChatNew vsplit", description = "Open a fresh chat in a vertical split window." },
    { ":GpChatNew split", description = "Open a fresh chat in a horizontal split window." },
    { ":GpChatNew tabnew", description = "Open a fresh chat in a new tab." },
    { ":GpChatPaste popup", description = "Paste into the latest chat in a popup window." },
    { ":GpChatPaste vsplit", description = "Paste into the latest chat in a vertical split window." },
    { ":GpChatPaste split", description = "Paste into the latest chat in a horizontal split window." },
    { ":GpChatPaste tabnew", description = "Paste into the latest chat in a new tab." },
    { ":GpChatToggle popup", description = "Toggle chat in a popup window." },
    { ":GpChatToggle vsplit", description = "Toggle chat in a vertical split window." },
    { ":GpChatToggle split", description = "Toggle chat in a horizontal split window." },
    { ":GpChatToggle tabnew", description = "Toggle chat in a new tab." },
    { ":GpChatFinder", description = "Open a dialog to search through chats." },
    { ":GpChatRespond", description = "Request a new GPT response for the current chat." },
    { ":GpChatDelete", description = "Delete the current chat." },
    --[[ Text/Code Commands ]]
    { ":GpRewrite", description = "Opens a dialog for entering a prompt." },
    { ":GpAppend", description = "Similar to :GpRewrite, but the answer is added after the current line, visual selection, or range." },
    { ":GpPrepend", description = "Similar to :GpRewrite, but the answer is added before the current line, visual selection, or range." },
    { ":GpEnew", description = "Similar to :GpRewrite, but the answer is added into a new buffer in the current window." },
    { ":GpNew", description = "Similar to :GpRewrite, but the answer is added into a new horizontal split window." },
    { ":GpVnew", description = "Similar to :GpRewrite, but the answer is added into a new vertical split window." },
    { ":GpTabnew", description = "Similar to :GpRewrite, but the answer is added into a new tab." },
    { ":GpPopup", description = "Similar to :GpRewrite, but the answer is added into a pop-up window." },
    { ":GpImplement", description = "Example hook command to develop code from comments in a visual selection or specified range." },
    { ":GpContext", description = "Provides custom context per repository." },
    --[[ Speech Commands ]]
    -- { ":GpWhisperRewrite", "Similar to :GpRewrite, but the prompt instruction dialog uses transcribed spoken instructions." },
    -- { ":GpWhisperAppend", "Similar to :GpAppend, but the prompt instruction dialog uses transcribed spoken instructions for adding content after the current line, visual selection, or range." },
    -- { ":GpWhisperPrepend", "Similar to :GpPrepend, but the prompt instruction dialog uses transcribed spoken instructions for adding content before the current line, selection, or range." },
    -- { ":GpWhisperEnew", "Similar to :GpEnew, but the prompt instruction dialog uses transcribed spoken instructions for opening content in a new buffer within the current window." },
    -- { ":GpWhisperNew", "Similar to :GpNew, but the prompt instruction dialog uses transcribed spoken instructions for opening content in a new horizontal split window." },
    -- { ":GpWhisperVnew", "Similar to :GpVnew, but the prompt instruction dialog uses transcribed spoken instructions for opening content in a new vertical split window." },
    -- { ":GpWhisperTabnew", "Similar to :GpTabnew, but the prompt instruction dialog uses transcribed spoken instructions for opening content in a new tab." },
    -- { ":GpWhisperPopup", "Similar to :GpPopup, but the prompt instruction dialog uses transcribed spoken instructions for displaying content in a pop-up window." },
    --[[ Agent Commands ]]
    { ":GpAgent", description = "Displays currently used agents for chat and command instructions." },
    { ":GpAgentNext", description = "Cycles between available agents based on the current buffer (chat agents if current buffer is a chat and command agents otherwise)." },
    { ":GpAgentPrev", description = "Cycles between available agents based on the current buffer (chat agents if current buffer is a chat and command agents otherwise)." },
    --[[ Image Commands ]]
    { ":GpImage", description = "Opens a dialog for entering a prompt describing wanted images." },
    { ":GpImageAgent", description = "Displays currently used image agent (configuration)." },
    --[[ Other Commands ]]
    { ":GpStop", description = "Stops all currently running responses and jobs." },
    { ":GpInspectPlugin", description = "Inspects the GPT prompt plugin object in a new scratch buffer." },
})
