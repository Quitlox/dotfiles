-- Dependencies
import("nvim-treesitter.install", function(treesitter) treesitter.update({ with_sync = true }) end)

import("nvim-treesitter.configs", function(treesitter)
    treesitter.setup({
        ensure_installed = {
            -- Main Languages
            "c",
            "lua",
            "rust",
            "python",
            "java",
            "lua",
            -- Shell
            "vim",
            "bash",
            "cpp",
            -- Latex
            "latex",
            "bibtex",
            -- Build Environment
            "make",
            "cmake",
            "dockerfile",
            -- Supplemenatry Files
            "json",
            "jsonc",
            "markdown",
            "toml",
            "yaml",
            -- Web Development
            "graphql",
            "html",
            "scss",
            "tsx",
            "typescript",
            -- Dependencies
            "regex",
            "markdown_inline",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = true,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        ----- Highlight -----
        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages

            additional_vim_regex_highlighting = { "latex" },
            disable = { "latex" },
        },

        ----- Rainbow -----
        -- with: p00f/nvim-ts-rainbow
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 20000,
            disable = { "latex" },
        },

        ----- Indenting -----
        indent = {
            enable = true,
            -- See yati below
            disable = { "python", "latex" },
        },
        -- Temporary plugin for Python indentation
        -- since the default treesitter implementation sucks.
        yati = { enable = true },

        ----- Endwise -----
        -- The autopairs for languages like lua (i.e. using 'end')
        endwise = {
            enable = true,
        },

        ----- AutoTag -----
        -- The autopairs for languages like html
        autotag = {
            enable = true,
        },

        ----- Text Objects -----
        -- with: nvim-treesitter/nvim-treesitter-textobjects
        textobjects = {
            move = {
                enable = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                    ["]a"] = "@parameter.inner",
                    ["]b"] = "@block.outer",
                    -- ["]s"] = "@statement.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                    ["]A"] = "@parameter.outer",
                    ["]B"] = "@block.outer",
                    ["]L"] = "@loop.outer",
                    -- ["]S"] = "@statement.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                    ["[a"] = "@parameter.inner",
                    ["[b"] = "@block.outer",
                    ["[l"] = "@loop.outer",
                    -- ["[s"] = "@statement.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                    ["[A"] = "@parameter.outer",
                    ["[B"] = "@block.outer",
                    ["[L"] = "@loop.outer",
                    -- ["[S"] = "@statement.outer",
                },
            },
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    -- ["as"] = "@statement.outer",
                    -- ["is"] = "@statement.inner",
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "v", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
            },
        },

        ----- Comment -----
        -- with: JoosepAlviste/nvim-ts-context-commentstring
        context_commentstring = {
            enable = true,
        },
    })
end)

-- Spelling Highlight
-- xtermcolors: https://www.ditig.com/256-colors-cheat-sheet
vim.cmd([[hi SpellBad guifg=None guibg=None guisp='DarkOliveGreen3' gui=undercurl]])
vim.cmd([[hi SpellCap guifg=None guibg=None guisp='Olive' gui=undercurl]])
vim.cmd([[hi SpellRare guifg=None guibg=None guisp='Olive' gui=undercurl]])
vim.cmd([[hi SpellLocal guifg=None guibg=None guisp='Olive' gui=undercurl]])
