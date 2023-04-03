----------------------------------------------------------------------
--                              LSP UI                              --
----------------------------------------------------------------------

return {
    {
    "glepnir/lspsaga.nvim",
    version = "",
    dependencies = {
      -- {"nvim-tree/nvim-web-devicons"},
      --Please make sure you install markdown and markdown_inline parser
      {"nvim-treesitter/nvim-treesitter"}
    },
    config = function(_, opts)
        require("lspsaga").setup(opts)
    end,
    opts = {
        lightbulb = {
            enable = false,
        },
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
        symbol_in_winbar = {
            enable = false,
        },
    },
},
    {
        "zbirenbaum/neodim",
        opts = {
            hide = {
                signs = false,
                virtual_text = false,
                underline = true,
            },
        },
        config = true,
        event = "LspAttach",
    },
}
