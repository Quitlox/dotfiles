; extends

((decorated_definition)?
  (function_definition
    name: (identifier) @function.name
    body: (block)? @function.inner)) @function.outer

((decorated_definition)?
  (class_definition
    name: (identifier) @class.name
    body: (block)? @class.inner)) @class.outer

; String inner/outer using offset! (replaces deprecated make-range!)
; Simple single/double quotes: " or '
((string
  (string_start) @_start
  (#match? @_start "^[\"']$")
) @string.inner @string.outer
(#offset! @string.inner 0 1 0 -1))

; f/r/b/u strings: f" r" b" u" (and uppercase variants)
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU][\"']$")
) @string.inner @string.outer
(#offset! @string.inner 0 2 0 -1))

; fr/rf/br/rb strings (two prefix chars)
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU][fFrRbBuU][\"']$")
) @string.inner @string.outer
(#offset! @string.inner 0 3 0 -1))

; Triple double quotes: """
((string
  (string_start) @_start
  (#eq? @_start "\"\"\"")
) @string.inner @string.outer
(#offset! @string.inner 0 3 0 -3))

; Triple single quotes: '''
((string
  (string_start) @_start
  (#eq? @_start "'''")
) @string.inner @string.outer
(#offset! @string.inner 0 3 0 -3))

; f/r/b/u triple double quotes: f""" r""" etc.
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU]\"\"\"$")
) @string.inner @string.outer
(#offset! @string.inner 0 4 0 -3))

; f/r/b/u triple single quotes: f''' r''' etc.
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU]'''$")
) @string.inner @string.outer
(#offset! @string.inner 0 4 0 -3))

; fr/rf triple double quotes: rf""" fr""" etc.
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU][fFrRbBuU]\"\"\"$")
) @string.inner @string.outer
(#offset! @string.inner 0 5 0 -3))

; fr/rf triple single quotes: rf''' fr''' etc.
((string
  (string_start) @_start
  (#match? @_start "^[fFrRbBuU][fFrRbBuU]'''$")
) @string.inner @string.outer
(#offset! @string.inner 0 5 0 -3))
