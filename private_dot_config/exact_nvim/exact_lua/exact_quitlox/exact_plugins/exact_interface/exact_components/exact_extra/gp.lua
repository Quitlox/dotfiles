return {
    {
        "robitx/gp.nvim",
        opts = {
            chat_confirm_delete = false,
            toggle_target = "popup",
        },
        -- stylua: ignore
        cmd = {
            "GpChatNew", "GpChatPaste", "GpChatToggle", "GpChatFinder", "GpChatRespond", "GpChatDelete",
            "GpRewrite", "GpAppend", "GpPrepend", "GpEnew", "GpNew", "GpVnew", "GpTabnew", "GpPopup", "GpImplement", "GpContext",
            -- "GpWhisperRewrite", "GpWhisperAppend", "GpWhisperPrepend", "GpWhisperEnew", "GpWhisperNew", "GpWhisperVnew", "GpWhisperTabnew", "GpWhisperPopup",
            "GpAgent", "GpAgentNext", "GpAgentPrev",
            "GpImage", "GpImageAgent",
            "GpStop", "GpInspectPlugin",
        },
        keys = {
            -- Chat Commands
            { "<C-g>c", ":GpChatNew popup<cr>", desc = "NewChat", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g>t", ":GpChatToggle<cr>", desc = "ToggleChat", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g>f", ":GpChatFinder<cr>", desc = "ChatFinder", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },

            { "<C-g>c", ":'<,'>GpChatNew<cr>", desc = "VisualChatNew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g>p", ":'<,'>GpChatPaste<cr>", desc = "VisualChatPaste", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g>t", ":'<,'>GpChatToggle<cr>", desc = "VisualToggleChat", mode = { "v" }, noremap = true, silent = true, nowait = true },

            { "<C-g><C-v>", ":GpChatNew split<cr>", desc = "NewChat split", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g><C-b>", ":GpChatNew vsplit<cr>", desc = "NewChat vsplit", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g><Tab>", ":GpChatNew tabnew<cr>", desc = "NewChat tabnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },

            { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "VisualChatNew split", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "VisualChatNew vsplit", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g><Tab>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "VisualChatNew tabnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- Prompt Commands
            { "<C-g>r", ":GpRewrite<cr>", desc = "InlineRewrite", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g>a", ":GpAppend<cr>", desc = "Append", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g>b", ":GpPrepend<cr>", desc = "Prepend", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },

            { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "VisualInlineRewrite", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "VisualAppend", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "VisualPrepend", mode = { "v" }, noremap = true, silent = true, nowait = true },
            { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "VisualImplement", mode = { "v" }, noremap = true, silent = true, nowait = true },

            -- { "<C-g>gp", ":GpPopup<cr>", desc = "Popup", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>ge", ":GpEnew<cr>", desc = "GpEnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gn", ":GpNew<cr>", desc = "GpNew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gv", ":GpVnew<cr>", desc = "GpVnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gt", ":GpTabnew<cr>", desc = "GpTabnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },

            -- { "<C-g>gp", ":'<,'>GpPopup<cr>", desc = "VisualPopup", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>ge", ":'<,'>GpEnew<cr>", desc = "VisualGpEnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gn", ":'<,'>GpNew<cr>", desc = "VisualGpNew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gv", ":'<,'>GpVnew<cr>", desc = "VisualGpVnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>gt", ":'<,'>GpTabnew<cr>", desc = "VisualGpTabnew", mode = { "v" }, noremap = true, silent = true, nowait = true },

            { "<C-g>x", ":GpContext<cr>", desc = "ToggleContext", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            { "<C-g>x", ":'<,'>GpContext<cr>", desc = "VisualToggleContext", mode = { "v" }, noremap = true, silent = true, nowait = true },

            { "<C-g>s", ":GpStop<cr>", desc = "Stop", mode = { "n", "i", "v", "x" }, noremap = true, silent = true, nowait = true },
            { "<C-g>n", ":GpNextAgent<cr>", desc = "NextAgent", mode = { "n", "i", "v", "x" }, noremap = true, silent = true, nowait = true },

            -- Optional Whisper Commands
            -- { "<C-g>ww", ":GpWhisper<cr>", desc = "Whisper", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>ww", ":'<,'>GpWhisper<cr>", desc = "VisualWhisper", mode = { "v" }, noremap = true, silent = true, nowait = true },
            --
            -- { "<C-g>wr", ":GpWhisperRewrite<cr>", desc = "WhisperRewrite", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wa", ":GpWhisperAppend<cr>", desc = "WhisperAppend", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wb", ":GpWhisperPrepend<cr>", desc = "WhisperPrepend", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            --
            -- { "<C-g>wr", ":'<,'>GpWhisperRewrite<cr>", desc = "VisualWhisperRewrite", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wa", ":'<,'>GpWhisperAppend<cr>", desc = "VisualWhisperAppend", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wb", ":'<,'>GpWhisperPrepend<cr>", desc = "VisualWhisperPrepend", mode = { "v" }, noremap = true, silent = true, nowait = true },
            --
            -- { "<C-g>wp", ":GpWhisperPopup<cr>", desc = "WhisperPopup", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>we", ":GpWhisperEnew<cr>", desc = "WhisperEnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wn", ":GpWhisperNew<cr>", desc = "WhisperNew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wv", ":GpWhisperVnew<cr>", desc = "WhisperVnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wt", ":GpWhisperTabnew<cr>", desc = "WhisperTabnew", mode = { "n", "i" }, noremap = true, silent = true, nowait = true },
            --
            -- { "<C-g>wp", ":'<,'>GpWhisperPopup<cr>", desc = "VisualWhisperPopup", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>we", ":'<,'>GpWhisperEnew<cr>", desc = "VisualWhisperEnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wn", ":'<,'>GpWhisperNew<cr>", desc = "VisualWhisperNew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wv", ":'<,'>GpWhisperVnew<cr>", desc = "VisualWhisperVnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
            -- { "<C-g>wt", ":'<,'>GpWhisperTabnew<cr>", desc = "VisualWhisperTabnew", mode = { "v" }, noremap = true, silent = true, nowait = true },
        },
    },
    require("quitlox.util").legendary({
        --[[ Chat Commands ]]
        { ":GpChatNew popup", "Open a fresh chat in a popup window." },
        { ":GpChatNew vsplit", "Open a fresh chat in a vertical split window." },
        { ":GpChatNew split", "Open a fresh chat in a horizontal split window." },
        { ":GpChatNew tabnew", "Open a fresh chat in a new tab." },
        { ":GpChatPaste popup", "Paste into the latest chat in a popup window." },
        { ":GpChatPaste vsplit", "Paste into the latest chat in a vertical split window." },
        { ":GpChatPaste split", "Paste into the latest chat in a horizontal split window." },
        { ":GpChatPaste tabnew", "Paste into the latest chat in a new tab." },
        { ":GpChatToggle popup", "Toggle chat in a popup window." },
        { ":GpChatToggle vsplit", "Toggle chat in a vertical split window." },
        { ":GpChatToggle split", "Toggle chat in a horizontal split window." },
        { ":GpChatToggle tabnew", "Toggle chat in a new tab." },
        { ":GpChatFinder", "Open a dialog to search through chats." },
        { ":GpChatRespond", "Request a new GPT response for the current chat." },
        { ":GpChatDelete", "Delete the current chat." },
        --[[ Text/Code Commands ]]
        { ":GpRewrite", "Opens a dialog for entering a prompt." },
        { ":GpAppend", "Similar to :GpRewrite, but the answer is added after the current line, visual selection, or range." },
        { ":GpPrepend", "Similar to :GpRewrite, but the answer is added before the current line, visual selection, or range." },
        { ":GpEnew", "Similar to :GpRewrite, but the answer is added into a new buffer in the current window." },
        { ":GpNew", "Similar to :GpRewrite, but the answer is added into a new horizontal split window." },
        { ":GpVnew", "Similar to :GpRewrite, but the answer is added into a new vertical split window." },
        { ":GpTabnew", "Similar to :GpRewrite, but the answer is added into a new tab." },
        { ":GpPopup", "Similar to :GpRewrite, but the answer is added into a pop-up window." },
        { ":GpImplement", "Example hook command to develop code from comments in a visual selection or specified range." },
        { ":GpContext", "Provides custom context per repository." },
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
        { ":GpAgent", "Displays currently used agents for chat and command instructions." },
        { ":GpAgentNext", "Cycles between available agents based on the current buffer (chat agents if current buffer is a chat and command agents otherwise)." },
        { ":GpAgentPrev", "Cycles between available agents based on the current buffer (chat agents if current buffer is a chat and command agents otherwise)." },
        --[[ Image Commands ]]
        { ":GpImage", "Opens a dialog for entering a prompt describing wanted images." },
        { ":GpImageAgent", "Displays currently used image agent (configuration)." },
        --[[ Other Commands ]]
        { ":GpStop", "Stops all currently running responses and jobs." },
        { ":GpInspectPlugin", "Inspects the GPT prompt plugin object in a new scratch buffer." },
    }),
}
