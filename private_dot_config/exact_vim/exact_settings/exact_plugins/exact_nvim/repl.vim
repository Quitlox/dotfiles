if has('nvim') | finish | endif

lua << EOF
local iron = require("iron.core")

iron.setup {
  config = {
    -- Highlights the last sent block with bold
    --   highlight_last = "IronLastSent",
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = false,
    -- Your repl definitions come here
    repl_definition = {
      python = require("iron.fts.python").ipython,
      sh = {
        command = {"zsh"}
      }
    },
    -- how the REPL window will be opened, the default is opening
    -- a float window of height 40 at the bottom.
    repl_open_cmd = require('iron.view').curry.right(60),
    -- If the repl buffer is listed
    buflisted = false,

  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "<localleader>rs",
    visual_send = "<localleader>rs",
    send_file = "<localleader>rf",
    send_line = "<localleader>rl",
    send_mark = "<localleader>rm",
    --mark_motion = "<localleader>mc",
    --mark_visual = "<localleader>mc",
    --remove_mark = "<localleader>md",
    cr = "<localleader>r<cr>",
    --interrupt = "<localleader>s<localleader>",
    exit = "<localleader>re",
    clear = "<localleader>rc",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  }
}

local wk = require("which-key")

wk.register({
  ["<localleader>"] = {
    r = {
      name = "REPL",
      t = {":IronRepl<cr>", "[r]epl [t]oggle"},
      r = {":IronRestart<cr>", "[r]epl [r]estart"},
      g = {":IronFocus<cr>", "[r]epl focus"},
      p = {":IronSend ", "[r]epl [p]rompt"},
      s = "[r]epl [s]end visual",
      f = "[r]epl send [f]ile",
      l = "[r]epl send [l]ine",
      m = "[r]epl send [m]ark",
      e = "[r]epl [e]xit",
      c = "[r]epl [c]lear",
    },
  }
})
EOF
