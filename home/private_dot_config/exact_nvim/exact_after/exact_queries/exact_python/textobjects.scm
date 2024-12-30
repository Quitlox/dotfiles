; extends

((decorated_definition)?
  (function_definition
    name: (identifier) @function.name
    body: (block)? @function.inner)) @function.outer

((decorated_definition)?
  (class_definition
    name: (identifier) @class.name
    body: (block)? @class.inner)) @class.outer
