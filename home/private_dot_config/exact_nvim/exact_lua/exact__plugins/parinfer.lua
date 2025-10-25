local default_filetypes = { "clojure", "scheme", "lisp", "racket", "hy", "fennel", "janet", "carp", "wast", "yuck" }
local custom_filetypes = { "scm" }

vim.g.parinfer_filetypes = vim.tbl_extend("force", default_filetypes, custom_filetypes)
