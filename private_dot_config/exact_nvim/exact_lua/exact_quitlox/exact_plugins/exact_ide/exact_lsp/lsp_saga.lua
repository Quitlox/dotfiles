----------------------------------------------------------------------
--                              LSP UI                              --
----------------------------------------------------------------------

return {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function(_, opts) require("lspsaga").setup(opts) end,
    dependencies = {
        -- {"nvim-tree/nvim-web-devicons"},
        --Please make sure you install markdown and markdown_inline parser
        { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
        max_preview_lines = 20,

        code_action_keys = {
            quit = "<ESC>",
            exec = "<CR>",
        },
        definition_action_keys = {
            quit = "<ESC>",
        },
        finder_action_keys = {
            open = "<CR>",
            vsplit = "b",
            split = "v",
            quit = "<ESC>",
            scroll_down = "<C-d>",
            scroll_up = "<C-u>",
        },
        lightbulb = {
            enable = false,
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
        symbol_in_winbar = {
            enable = false,
        },

        ui = {
            kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        },
    },
}
