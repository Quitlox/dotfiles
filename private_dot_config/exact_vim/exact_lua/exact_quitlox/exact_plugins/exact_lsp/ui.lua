----------------------------------------------------------------------
--                              LSP UI                              --
----------------------------------------------------------------------
-- Require LspSaga
local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if not lspsaga_ok then return end

-- Setup
lspsaga.setup({
    max_preview_lines = 20,
    finder_action_keys = {
        open = "<CR>",
        vsplit = "b",
        split = "v",
        quit = "<ESC>",
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
    },
    code_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
    },
    definition_action_keys = {
        quit = "<ESC>",
    },
    rename_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
    },
    rename_prompt_prefix = "➤",
    rename_output_qflist = {
        enable = false,
        auto_open_qflist = false,
    },
    symbol_in_winbar={
        enable = false,
    },
})
