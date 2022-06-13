if !has('nvim') | finish | endif

"#######################################
"### SETTINGS                        ###
"#######################################

lua << EOF
require("which-key").setup {
  plugins = {
    presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = false,
        z = true,
        g = false,
    },
  },
  layout = {
    align = "center",
  }
}

local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    s = { ":wa<cr>", "save" },
  }
})

----------------------------------------
-- KEYBINDINGS: WINDOW
----------------------------------------
wk.register({
  ["<leader>"] = {
    s = { ":wa<cr>", "save" },
    w = {
      name = "window",
      j = { "<C-W>j", "focus [w]indow down" },
      k = { "<C-W>k", "focus [w]indow up" },
      h = { "<C-W>h", "focus [w]indow left" },
      l = { "<C-W>l", "focus [w]indow right" },
      o = { "<C-W>o", "[w]indow [o]nly" },
      v = { "<C-W>s", "[w]indow split vertical" },
      b = { "<C-W>v", "[w]indow split horizontal" },
      d = { "<C-W>q", "[w]indow [d]elete" },
      w = { ":new<CR>", ":new <window>" },
      r = {
        name = "resize",
        k = { ":resize +2<CR>", "[w]indow [r]esize up" },
        j = { ":resize -2<CR>", "[w]indow [r]esize down" },
        h = { ":vertical resize -2<CR>", "[w]indow [r]esize left" },
        l = { ":vertical resize +2<CR>", "[w]indow [r]esize right" },
        ["<Up>"] = { ":resize +2<CR>", "which_key_ignore" },
        ["<Down>"] = { ":resize -2<CR>", "which_key_ignore" },
        ["<Right>"] = { ":vertical resize +2<CR>", "which_key_ignore" },
        ["<Left>"] = { ":vertical resize -2<CR>", "which_key_ignore" },
      },
    },
  }
})

----------------------------------------
-- KEYBINDINGS: BUFFER
----------------------------------------
wk.register({
  ["<leader>"] = {
    b = {
      name = "buffer",
      d = { ":Bdelete<cr>", "[b]uffer [d]elete" },
      n = { ":<C-u>execute 'call Bswitch_normal(' . v:count1 . ', \"next\")'<CR>", "[b]uffer [n]ext" },
      p = { ":<C-u>execute 'call Bswitch_normal(' . v:count1 . ', \"previous\")'<CR>", "[b]uffer [p]revious" },
      o = { ":BufOnly<cr>", "[b]uffer [o]nly" },
      s = { ":w<cr>", "[b]uffer [s]ave" },
    },
  }
})

----------------------------------------
-- KEYBINDINGS: TAB
----------------------------------------
wk.register({
  ["<leader>"] = {
    T = {
      name = "Tab",
      t = { ":tabnew<cr>", "[T]ab :new" },
      o = { ":tabonly<cr>", "[T]ab [o]nly" },
      d = { ":tabclose<cr>", "[T]ab [d]elete" },
      n = { ":tabnext<cr>", "[T]ab [n]next" },
      p = { ":tabprevious<cr>", "[T]ab [p]revious" },
      l = { ":exe \"tabn \".g:lasttab<CR>", "[T]ab [l]ast" },
      m = {
        name = "move",
        h = { ":-tabmove<cr>", "[T]ab [m]ove left" },
        l = { ":+tabmove<cr>", "[T]ab [m]ove right" },
      },
    },
  },
})

----------------------------------------
-- KEYBINDINGS: TOGGLES
----------------------------------------
wk.register({
  ["<leader>"] = {
    T = {
      name = "toggle",
      f = { ":NERDTreeMirror<cr>:NERDTreeToggle<cr>", "[t]oggle [f]iletree" },
      s = { ":TagbarToggle<cr>", "[t]oggle [s]ymbols" },
      g = { ":IndentLinesToggle<cr>", "[t]oggle [g]uides" },
      c = { ":CloseTagToggleBuffer<cr>", "[t]oggle [c]lose tag" },
      r = { ":RainbowToggle<cr>", "[t]oggle [r]ainbow parentheses" },
      p = { ":TogglePencil<cr>", "[t]oggle [p]encil" },
      y = { ":Goyo<cr>", "[t]oggle go[y]o" },
    },
  },
})

----------------------------------------
-- KEYBINDINGS: FIND
----------------------------------------
wk.register({
  ["<leader>"] = {
    f = {
      name = "find",
      l = { ":NERDTreeFind<CR>", "[f]ind [l]ocate" },
      a = { "<cmd>Telescope live_grep theme=dropdown<cr>", "[f]ind [a]ll" },
      -- f = { "<cmd>Telescope live_grep theme=dropdown<cr>", "[f]ind" },
      -- m = { "<cmd>Telescope marks theme=dropdown<cr>", "[f]ind [m]arks" },
      -- j = { "<cmd>Telescope jumplist theme=dropdown<cr>", "[f]ind [j]umplist" },
      -- b = { "<cmd>Telescope buffer theme=dropdown<cr>", "[f]ind [b]uffers" },
    },
  }
})

----------------------------------------
-- KEYBINDINGS: OPEN
----------------------------------------
wk.register({
  ["<leader>"] = {
    o = {
      name = "open",
      f = { "<cmd>Telescope frecency theme=dropdown<cr>", "[o]pen [f]ile" },
      b = { "<cmd>Telescope buffers theme=dropdown<cr>", "[o]pen [b]uffer" },
      c = { ":<C-u>CocList commands<cr>", "[o]pen [c]ommands", silent=true },
      m = { "<cmd>Telescope man_pages theme=dropdown <cr>", "[f]ind [m]an page" },
      h = { "<cmd>Telescope help_tags theme=dropdown<cr>", "[o]pen [h]elp" },
    },
  },
})

----------------------------------------
-- KEYBINDINGS: MISCELLANEOUS
----------------------------------------
wk.register({
  ["<leader>"] = {
    v = {
      name = "vim",
      s = { ":source ~/.config/vim/vimrc<cr>", "[v]im [s]ource vimrc" },
      u = { ":DeinUpdate<cr>", "[v]im [u]pdate plugins" },
      l = {
        name = "list",
        f = { "<cmd>Telescope filetypes theme=dropdown<cr>", "[v]im [l]ist [f]iletypes" },
        r = { "<cmd>Telescope registers theme=dropdown<cr>", "[v]im [l]ist [r]egisters" },
        o = { "<cmd>Telescope vim_options theme=dropdown<cr>", "[v]im [l]ist [o]ptions" },
        c = { "<cmd>Telescope autocommands theme=dropdown<cr>", "[v]im [l]ist [a]utocommands" },
      }
    },
    y = "yanklist",
    ["<space>"] = "which_key_ignore", -- EasyMotion
    ["<enter>"] = "which_key_ignore", -- NoHighlight
  },
})

----------------------------------------
-- PLUGIN: FUGITIVE
----------------------------------------
wk.register({
  ["<leader>"] = {
    g = {
      name = "git",
      s = { ":G<cr>", "[g]it [s]tatus" },
      c = { ":Git commit<cr>", "[g]it [c]ommit" },
      -- Diffget (f is left index finger, j is right, as in left and right, ..get it?..)
      j = { ":diffget //3<cr>", "[g]it :diffget //3" },
      f = { ":diffget //2<cr>", "[g]it :diffget //2" },
      -- list some git stuff using Telescope
      l = {
        name = "list",
        c = { "<cmd>Telescope commits theme=dropdown<cr>", "[g]it [l]ist [c]ommits" },
        b = { "<cmd>Telescope branches theme=dropdown<cr>", "[g]it [l]ist [b]ranches" },
        s = { "<cmd>Telescope stash theme=dropdown<cr>", "[g]it [l]ist [s]tash" },
      }
    },
  },
})

----------------------------------------
-- PLUGIN: COMMENTARY
----------------------------------------
wk.register({
  ["<leader>"] = {
    c = {
      name = "comment",
      c = "comment",
      n = "force nesting",
      m = "minimal",
      i = "invert",
      ["$"] = "till EOL",
      A = "append",
      a = "alt. delim.",
      u = "uncomment",
      s = "sexy",
      b = "align both",
      l = "align left",
      y = "yank",
    },
  },
})

----------------------------------------
-- PLUGIN: VIMTEX (LATEX)
----------------------------------------
wk.register({
  ["<localleader>"] = {
    l = {
      name = "[L]aTeX",
      a = "context menu",
      C = "[c]lean full",
      c = "[c]lean",
      e = "[e]rrors",
      g = "status",
      G = "status all",
      I = "[i]nfo full",
      i = "[i]nfo",
      K = "stop all",
      k = "stop",
      l = "compile",
      L = "compile selected",
      m = "i[m]aps list",
      o = "compile [o]utput",
      q = "log",
      s = "toggle main",
      t = "[t]oc open",
      T = "[t]oc toggle",
      v = "[v]iew",
      X = "reload state",
      x = "reload",
    },
  },
})

----------------------------------------
-- PLUGIN: COC (IDE)
----------------------------------------
wk.register({
  ["<leader>"] = {
    i = {
      name = "IDE",
      d = { ":<C-u>CocList diagnostics<cr>",    "[i]pen [d]iagnostics" },
      e = { ":<C-u>CocList extensions<cr>",     "[i]pen [e]xtensions" },
      o = { ":<C-u>CocList outline<cr>",        "[i]pen [o]utline" },
      s = { ":<C-u>CocList -I symbols<cr>",     "[i]pen [s]ymbols" },
      l = { ":<C-u>CocList<cr>",                "[i]pen [l]ist" },
      m = { ":<C-u>CocList marketplace<cr>",    "[i]pen [m]arketplace" },
      c = { ":<C-u>CocList commands<cr>",       "[i]pen [c]ommands" },
    },
  },
}, {
  mode = "n",
  silent = true,
})

wk.register({
  g = {
    name = "go",
    d = { "<Plug>(coc-definition)", "definition" },
    y = { "<Plug>(coc-type-definition)", "type definition" },
    i = { "<Plug>(coc-implementation)", "implementation" },
    r = { "<Plug>(coc-references)", "references" },
    f = { ":call CocAction('format')<cr>", "format" },
    a = { "<Plug>(coc-codeaction-cursor)", "code-action-cursor" },
    ["<enter>"] = { "<Plug>(coc-fix-current)", "fix-current" },
    h = { ":call CocAction('doHover')<cr>", "hover" },
    o = { ":call CocAction('runCommand', 'editor.action.organizeImport')<cr>", "organise imports" },

    w = { ":StripWhitespace<cr>", "strip-whitespace" },

    ["0"] = "which_key_ignore",
    ["$"] = "which_key_ignore",
    ["%"] = "which_key_ignore",
    ["j"] = "which_key_ignore",
    ["k"] = "which_key_ignore",
    ["x"] = "which_key_ignore",
    ["e"] = "which_key_ignore",
    ["g"] = "which_key_ignore"
  },
})

EOF

