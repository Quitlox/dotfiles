-- +---------------------------------------------------------+
-- | azorng/goose.nvim: Neovim + Goose Integration           |
-- +---------------------------------------------------------+

require("goose").setup({
    default_global_keymaps = true, -- If false, disables all default global keymaps
    keymap = {
        global = {
            toggle = "<localleader>gg", -- Open goose. Close if opened
            open_input = "<localleader>gi", -- Opens and focuses on input window on insert mode
            open_input_new_session = "<localleader>gI", -- Opens and focuses on input window on insert mode. Creates a new session
            open_output = "<localleader>go", -- Opens and focuses on output window
            toggle_focus = "<localleader>gt", -- Toggle focus between goose and last window
            close = "<localleader>gq", -- Close UI windows
            toggle_fullscreen = "<localleader>gf", -- Toggle between normal and fullscreen mode
            select_session = "<localleader>gs", -- Select and load a goose session
            goose_mode_chat = "<localleader>gmc", -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
            goose_mode_auto = "<localleader>gma", -- Set goose mode to `auto`. (Default mode with full agent capabilities)
            configure_provider = "<localleader>gp", -- Quick provider and model switch from predefined list
            diff_open = "<localleader>gd", -- Opens a diff tab of a modified file since the last goose prompt
            diff_next = "<localleader>g]", -- Navigate to next file diff
            diff_prev = "<localleader>g[", -- Navigate to previous file diff
            diff_close = "<localleader>gc", -- Close diff view tab and return to normal editing
            diff_revert_all = "<localleader>gra", -- Revert all file changes since the last goose prompt
            diff_revert_this = "<localleader>grt", -- Revert current file changes since the last goose prompt
        },
        window = {
            submit = "<cr>", -- Submit prompt
            close = "<esc>", -- Close UI windows
            stop = "<C-c>", -- Stop goose while it is running
            next_message = "]]", -- Navigate to next message in the conversation
            prev_message = "[[", -- Navigate to previous message in the conversation
            mention_file = "@", -- Pick a file and add to context. See File Mentions section
            toggle_pane = "<tab>", -- Toggle between input and output panes
            prev_prompt_history = "<up>", -- Navigate to previous prompt in history
            next_prompt_history = "<down>", -- Navigate to next prompt in history
        },
    },
    providers = {
        -- Define available providers and their models for quick model switching
        -- anthropic|azure|bedrock|databricks|google|groq|ollama|openai|openrouter
        google = {
            "gemini-2.5-pro-preview-06-05",
            "gemini-2.5-flash-preview-05-20",
        },
        anthropic = {
            "claude-3-7-sonnet-latest",
            "claude-sonnet-4-0",
            "claude-opus-4-0",
        },
    },
})

require("which-key").add({
    { "<localleader>g", group = "Goose" },
})
