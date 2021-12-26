if !has('nvim-0.5') | finish | endif


"#######################################
"### SETTINGS                        ###
"#######################################

lua << EOF
require("which-key").setup {}
local wk = require("which-key")

-- KEYBINDINGS: NAGIVATION
wk.register({
  ["<leader>"] = {
    f = {
      name = "file",
      w = "[f]file [w]rite",
      W = "[f]ile [w]rite all",
      t = "[f]ile [t]ree",
      l = "[f]ile [l]ocate",
      f = "[f]ile [f]format",
    },
    w = {
      name = "window",
      j = "focus [w]indow down",
      k = "focus [w]indow up",
      h = "focus [w]indow left",
      l = "focus [w]indow right",
      o = "[w]indow [o]nly",
      v = "[w]indow split vertical",
      b = "[w]indow split horizontal",
      d = "[w]indow [d]elete",
      w = ":new <window>",
      r = {
        name = "resize",
        k = "[w]indow [r]esize up",
        j = "[w]indow [r]esize down",
        h = "[w]indow [r]esize left",
        l = "[w]indow [r]esize right",
        ["<Up>"] = "which_key_ignore",
        ["<Down>"] = "which_key_ignore",
        ["<Right>"] = "which_key_ignore",
        ["<Left>"] = "which_key_ignore",
      },
    },
    b = {
      name = "buffer",
      D = "[b]uffer [D]elete All",
      d = "[b]uffer [d]elete",
      n = "[b]uffer [n]ext",
      p = "[b]uffer [p]revious",
      o = "[b]uffer [o]nly",
    },
  }
})

-- KEYBINDINGS: TOGGLES
wk.register({
  ["<leader>"] = {
    t = {
      name = "UI-Toggle",
      t = "[t]oggle [t]agbar",
      f = "[t]oggle [f]iletree",
      y = "[t]oggle go[y]o",
    },
    T = {
      name = "toggle",
      g = "[T]oggle [g]uides",
      c = "[T]oggle [c]lose tag",
      r = "[T]oggle [r]ainbow parentheses",
      p = "[T]oggle [p]encil",
    },
  },
})

-- KEYBINDINGS: TABS
wk.register({
  ["<localleader>"] = {
    t = {
      name = "tab",
      t = "[t]ab :new",
      o = "[t]ab [o]nly",
      d = "[t]ab [d]elete",
      n = "[t]ab [n]next",
      p = "[t]ab [p]revious",
      l = "[t]ab [l]ast",
      m = {
        name = "move",
        h = "[t]ab [m]ove left",
        l = "[t]ab [m]ove right",
      },
    },
  },
})

-- KEYBINDINGS: COMMENT
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

-- KEYBINDINGS: GENERAL
wk.register({
  ["<leader>"] = {
    v = {
      name = "vim",
      s = "[v]im [s]ource vimrc",
      u = "[v]im [u]pdate plugins",
    },
    y = "yanklist",
    ["<space>"] = "which_key_ignore", -- EasyMotion
    ["<enter>"] = "which_key_ignore", -- NoHighlight
  },
  g = {
    name = "go",
    w = "[g]o strip [w]hitespace",
  },
})

-- KEYBINDINGS: NERDtree
wk.register({
  ["<leader>"] = {
    o = {
      name = "open",
      f = "[o]pen [f]ile",
      b = "[o]pen [b]uffer",
      r = "[o]pen [r]ecent",
    },
  },
})

-- KEYBINDINGS: LATEX
wk.register({
  ["<leader>"] = {
    l = {
      name = "LaTeX",
      l = "[l]atex compile",
      v = "[l]atex [v]iew",
      e = "[l]atex [e]rrors",
      c = "[l]atex [c]lean",
      s = "[l]atex conceal [s]yntax",
    },
  },
})

EOF

