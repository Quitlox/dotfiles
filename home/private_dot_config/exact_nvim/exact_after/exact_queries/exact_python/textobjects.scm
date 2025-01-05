; extends

((decorated_definition)?
  (function_definition
    name: (identifier) @function.name
    body: (block)? @function.inner)) @function.outer

((decorated_definition)?
  (class_definition
    name: (identifier) @class.name
    body: (block)? @class.inner)) @class.outer

(string
  ((string_start)
  .
  (_) @_start
  (_)? @_end
  .
  (string_end))
  (#make-range! "string.inner" @_start @_end)
  ) @string.outer
