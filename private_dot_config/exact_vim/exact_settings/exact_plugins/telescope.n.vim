if !(has('nvim-0.6.0')) | finish | endif

lua << EOF

local actions = require("telescope.actions")
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    -- frecency = {
    --   default_workspace = 'CWD',
    -- },
  },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require("telescope").load_extension("frecency")

EOF


"#######################################
"### KEYBINDINGS                     ###
"#######################################

nnoremap <leader>of <cmd>Telescope frecency<cr>
nnoremap <leader>ob <cmd>Telescope buffers<cr>

nnoremap <leader>ff <cmd>Telescope frecency<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
