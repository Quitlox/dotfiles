-- +---------------------------------------------------------+
-- | folke/which-key.nvim: Keyboard Shortcut Helper          |
-- +---------------------------------------------------------+

require("which-key").setup({
    preset = "modern",
    sort = { "order", "group", "natural" },
    delay = function(ctx)
        return ctx.plugin and 0 or 400
    end,
    spec = {
        -- Leader key groups - organized hierarchically
        { "<leader>vu", "<cmd>Rocks sync<cr>", desc = "Update Plugins" },
        { "<leader><tab>", group = "Tab" },
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>v", group = "Vim" },
        { "<leader>T", group = "Toggle" },
        { "<leader>l", group = "Locate" },
        { "<leader>o", group = "Open" },
        { "<leader>w", group = "Window" },
        { "<leader>m", group = "Miscelleneous" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>s", group = "Snippet / Session" },
        { "<leader><leader>", group = "Lang" },
        { "<localleader>m", group = "Markdown" },
        { "gr", group = "LSP" },

        -- Text objects - for operating on different text boundaries
        { "a", group = "Around" },
        { "i", group = "Inside" },

        -- Basic editing operations - core vim editing commands
        -- { "c", desc = "Change" },
        -- { "d", desc = "Delete" },
        -- { "y", desc = "Yank" },
        -- { "x", desc = "Delete Character" },
        -- { "X", desc = "Delete Character Before" },
        -- { "s", desc = "Substitute" },
        -- { "r", desc = "Replace" },
        -- { "u", desc = "Undo" },
        -- { "U", desc = "Undo Line" },
        -- { "p", desc = "Put After" },
        -- { "P", desc = "Put Before" },
        -- { ".", desc = "Repeat Last Change" },
        -- { '"', desc = "Register" },

        -- Insert and append operations - entering insert mode variations
        -- { "i", desc = "Insert" },
        -- { "I", desc = "Insert at Beginning" },
        -- { "a", desc = "Append" },
        -- { "A", desc = "Append at End" },
        -- { "o", desc = "Open Line Below" },
        -- { "O", desc = "Open Line Above" },
        -- { "R", desc = "Replace Mode" },
        -- { "S", desc = "Substitute Line" },
        -- { "C", desc = "Change to End of Line" },
        -- { "D", desc = "Delete to End of Line" },
        -- { "Y", desc = "Yank Line" },

        -- Movement and navigation - cursor positioning commands
        -- { "w", desc = "Word Forward" },
        -- { "W", desc = "WORD Forward" },
        -- { "b", desc = "Word Backward" },
        -- { "B", desc = "WORD Backward" },
        -- { "e", desc = "End of Word" },
        -- { "E", desc = "End of WORD" },
        -- { "f", desc = "Find Character" },
        -- { "F", desc = "Find Character Backward" },
        -- { "t", desc = "Till Character" },
        -- { "T", desc = "Till Character Backward" },
        -- { ";", desc = "Repeat Find" },
        -- { ",", desc = "Repeat Find Backward" },
        -- { "H", desc = "Top of Screen" },
        -- { "M", desc = "Middle of Screen" },
        -- { "L", desc = "Bottom of Screen" },
        -- { "%", desc = "Matching Bracket" },

        -- Line operations - working with entire lines
        -- { "0", desc = "Start of Line" },
        -- { "^", desc = "First Non-blank" },
        -- { "$", desc = "End of Line" },
        -- { "+", desc = "Next Line First Non-blank" },
        -- { "-", desc = "Previous Line First Non-blank" },
        -- { "_", desc = "Current Line First Non-blank" },
        -- { "|", desc = "Column" },
        -- { "J", desc = "Join Lines" },
        -- { "gg", desc = "First Line" },
        -- { "G", desc = "Last Line" },

        -- Operator-pending mode - motions for use with operators like d, c, y
        -- { mode = "o", "w", desc = "to Word Forward" },
        -- { mode = "o", "W", desc = "to WORD Forward" },
        -- { mode = "o", "b", desc = "to Word Backward" },
        -- { mode = "o", "B", desc = "to WORD Backward" },
        -- { mode = "o", "e", desc = "to End of Word" },
        -- { mode = "o", "E", desc = "to End of WORD" },
        -- { mode = "o", "f", desc = "to Find Character" },
        -- { mode = "o", "F", desc = "to Find Character Backward" },
        -- { mode = "o", "t", desc = "to Till Character" },
        -- { mode = "o", "T", desc = "to Till Character Backward" },
        -- { mode = "o", "H", desc = "to Top of Screen" },
        -- { mode = "o", "M", desc = "to Middle of Screen" },
        -- { mode = "o", "L", desc = "to Bottom of Screen" },
        -- { mode = "o", "%", desc = "to Matching Bracket" },
        -- { mode = "o", "0", desc = "to Start of Line" },
        -- { mode = "o", "^", desc = "to First Non-blank" },
        -- { mode = "o", "$", desc = "to End of Line" },
        -- { mode = "o", "gg", desc = "to First Line" },
        -- { mode = "o", "G", desc = "to Last Line" },
        -- { mode = "o", "j", desc = "to Line Below" },
        -- { mode = "o", "k", desc = "to Line Above" },
        -- { mode = "o", "l", desc = "to Character Right" },
        -- { mode = "o", "h", desc = "to Character Left" },
        -- { mode = "o", "/", desc = "to Search Forward" },
        -- { mode = "o", "?", desc = "to Search Backward" },
        -- { mode = "o", "n", desc = "to Next Search" },
        -- { mode = "o", "N", desc = "to Previous Search" },

        -- Visual mode operations - selection and visual mode
        -- { "v", desc = "Visual" },
        -- { "V", desc = "Visual Line" },
        -- { mode = "v", "o", desc = "Other End of Selection" },
        -- { mode = "v", "u", desc = "Make Lowercase" },
        -- { mode = "v", "U", desc = "Make Uppercase" },
        -- { mode = "v", "~", desc = "Toggle Case" },
        -- { mode = "v", ">", desc = "Indent Right" },
        -- { mode = "v", "<", desc = "Indent Left" },

        -- Search operations - finding and replacing text
        -- { "/", desc = "Search Forward" },
        -- { "?", desc = "Search Backward" },
        -- { "*", desc = "Search Word Under Cursor" },
        -- { "#", desc = "Search Word Under Cursor (Backward)" },
        -- { "n", desc = "Next Search" },
        -- { "N", desc = "Previous Search" },
        -- { "&", desc = "Repeat Substitute" },

        -- Marks and macros - advanced vim features
        -- { "m", desc = "Set Mark" },
        -- { "'", desc = "Jump to Mark Line" },
        -- { "`", desc = "Jump to Mark" },
        -- { "q", desc = "Record Macro" },
        -- { "@", desc = "Execute Macro" },

        -- Formatting operations - text formatting and indentation
        -- { "=", desc = "Format" },
        -- { "<", desc = "Unindent", mode = "n" },
        -- { ">", desc = "Indent", mode = "n" },
        -- { "~", desc = "Toggle Case" },

        -- Insert mode operations - commands available in insert mode
        -- { mode = "i", "<C-r>", desc = "Insert Register" },
        -- { mode = "i", "<C-o>", desc = "Execute Normal Command" },
        -- { mode = "i", "<C-u>", desc = "Delete to Line Start" },
        -- { mode = "i", "<C-w>", desc = "Delete Word" },

        -- Function keys - debug and special functions
        -- { "<F7>", desc = "Debug Step Into" },
        -- { "<F8>", desc = "Debug Step Over" },
        -- { "<F9>", desc = "Debug Continue" },
        -- { "<S-F8>", desc = "Debug Step Out" },
        -- { "<S-F9>", desc = "Debug until Cursor" },

        -- System and special keys - vim system commands and modes
        -- { "K", desc = "Keyword Help" },
        -- { "Q", desc = "Ex Mode" },
        -- { "ZZ", desc = "Save and Quit" },
        -- { "ZQ", desc = "Quit Without Saving" },
        -- { "!", desc = "Filter Through Command" },
        -- { "\\", desc = "Local Leader" },

        -- Special groups - vim built-in command groups
        -- { "z", group = "Fold/View" },
        -- { "g", group = "Go/More" },
        -- { "]", group = "Next" },
        -- { "[", group = "Previous" },

        -- Plugin mappings - external plugin commands
        { "Plug", hidden = true },

        -- Hide defaults / editor
        -- { hidden = true, mode = { "n" }, { "Y" }, { "p" }, { "P" }, { "j" }, { "k" }, { ";" }, { "," }, { "n" }, { "N" } },
        -- { hidden = true, mode = { "n" }, { "r" }, { "t" }, { "T" }, { "f" }, { "t" }, { "T" }, { "<" }, { ">" } },
        { hidden = true, mode = { "n" }, { "<C-w>h" }, { "<C-w>l" }, { "<C-w>j" }, { "<C-w>k" }, { "<C-w>d" } },
        { hidden = true, mode = { "n" }, { "<C-h>" }, { "<C-l>" }, { "<C-j>" }, { "<C-k>" } },
        { "<leader><cr>", hidden = true },
        { "<2-LeftMouse>", hidden = true },

        -- Unmapped Defaults (see mapping.lua)
        { "<C-W><C-d>", hidden = true },
        -- Misc
    },
    plugins = {
        marks = false,
        registers = true,
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
        spelling = {
            enabled = true,
        },
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "", -- symbol used between a key and it's label
        group = " ", -- symbol prepended to a group
        ellipsis = "…",
        colors = false,
        mappings = false,
    },
    keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
})

vim.cmd([[hi link WhichKeyIcon WhichKeyDesc]])
