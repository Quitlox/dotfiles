if !has('nvim') | finish | endif

echo "nvim whichkey"

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
      name = "find",
      l = { ":NERDTreeFind<CR>", "[f]ind [l]ocate" },
    },
    W = { ":wa", "write all" },
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
    b = {
      name = "buffer",
      d = { ":Bdelete<cr>", "[b]uffer [d]elete" },
      n = { ":bnext<cr>", "[b]uffer [n]ext" },
      p = { ":bprevious<cr>", "[b]uffer [p]revious" },
      o = { ":BufOnly<cr>", "[b]uffer [o]nly" },
    },
  }
})

-- KEYBINDINGS: TABS
wk.register({
  ["<localleader>"] = {
    t = {
      name = "tab",
      t = { ":tabnew<cr>", "[t]ab :new" },
      o = { ":tabonly<cr>", "[t]ab [o]nly" },
      d = { ":tabclose<cr>", "[t]ab [d]elete" },
      n = { ":tabnext<cr>", "[t]ab [n]next" },
      p = { ":tabprevious<cr>", "[t]ab [p]revious" },
      l = { ":exe \"tabn \".g:lasttab<CR>", "[t]ab [l]ast" },
      m = {
        name = "move",
        h = { ":-tabmove<cr>", "[t]ab [m]ove left" },
        l = { ":+tabmove<cr>", "[t]ab [m]ove right" },
      },
    },
  },
})

-- KEYBINDINGS: TOGGLES
wk.register({
  ["<leader>"] = {
    t = {
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

-- KEYBINDINGS: MISCELLANEOUS
wk.register({
  ["<leader>"] = {
    v = {
      name = "vim",
      s = { ":source ~/.config/vim/vimrc<cr>", "[v]im [s]ource vimrc" },
      u = { ":DeinUpdate<cr>", "[v]im [u]pdate plugins" },
    },
    y = "yanklist",
    ["<space>"] = "which_key_ignore", -- EasyMotion
    ["<enter>"] = "which_key_ignore", -- NoHighlight
  },
  g = {
    name = "go",
    w = { ":StripWhitespace<cr>", "[g]o strip [w]hitespace" },
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


-- KEYBINDINGS: NERDtree
wk.register({
  ["<leader>"] = {
    o = {
      name = "open",
      f = { "<cmd>Telescope frecency<cr>", "[o]pen [f]ile" },
      b = { "<cmd>Telescope buffers<cr>", "[o]pen [b]uffer" },
      c = { ":<C-u>CocList commands<cr>", "[o]pen [c]ommands" },
    },
  },
})

-- KEYBINDINGS: CoC.vim
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
  nowait = true,
})

-- KEYBINDINGS: LATEX
wk.register({
  ["<leader>"] = {
    l = {
      name = "LaTeX",
      l = { ":VimtexCompile<cr>", "[l]atex compile" },
      v = { ":VimtexView<cr>", "[l]atex [v]iew" },
      e = { ":VimtexErrors<cr>", "[l]atex [e]rrors" },
      c = { ":VimtexClean<cr>", "[l]atex [c]lean" },
      s = { ":call ToggleVimtexConceal()<cr>", "[l]atex conceal [s]yntax" },
    },
  },
})

EOF

