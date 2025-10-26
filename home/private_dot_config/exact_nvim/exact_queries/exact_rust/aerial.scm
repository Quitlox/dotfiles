;; NOTE: We override (rather than extend) the upstream query so we can replace
;; several patterns with richer captures without producing duplicate symbols.

; DEFAULT: module declarations (`mod foo;` / inline modules).
(mod_item
  name: (identifier) @name
  (#set! "kind" "Module")) @symbol

; DEFAULT: enum declarations.
(enum_item
  name: (type_identifier) @name
  (#set! "kind" "Enum")) @symbol

; DEFAULT: struct declarations.
(struct_item
  name: (type_identifier) @name
  (#set! "kind" "Struct")) @symbol

; CUSTOM: include struct fields so members show beneath their parent.
(field_declaration
  name: (field_identifier) @name
  (#set! "kind" "Field")) @symbol

; DEFAULT: trait declarations.
(trait_item
  name: (type_identifier) @name
  (#set! "kind" "Interface")) @symbol

; CUSTOM: expose top-level `const` items.
(const_item
  name: (identifier) @name
  (#set! "kind" "Constant")) @symbol

; CUSTOM: expose top-level `static` items.
(static_item
  name: (identifier) @name
  (#set! "kind" "Constant")) @symbol

; CUSTOM: associated constants defined inside traits.
((trait_item
    body: (declaration_list
      (const_item
        name: (identifier) @name
        (#set! "kind" "Constant")) @symbol)))

; CUSTOM: associated constants defined inside impl blocks.
((impl_item
    body: (declaration_list
      (const_item
        name: (identifier) @name
        (#set! "kind" "Constant")) @symbol)))

; CUSTOM: functions with explicit return type (capture params/return).
(function_item
  name: (identifier) @name
  parameters: (parameters) @rust_params
  return_type: (_) @rust_return
  (#set! "kind" "Function")) @symbol

; CUSTOM: functions without explicit return type (still capture params).
(function_item
  name: (identifier) @name
  parameters: (parameters) @rust_params
  (#set! "kind" "Function")) @symbol

; CUSTOM: trait method signatures with explicit return type.
(function_signature_item
  name: (identifier) @name
  parameters: (parameters) @rust_params
  return_type: (_) @rust_return
  (#set! "kind" "Function")) @symbol

; CUSTOM: trait method signatures without explicit return type.
(function_signature_item
  name: (identifier) @name
  parameters: (parameters) @rust_params
  (#set! "kind" "Function")) @symbol

; OVERRIDE: impl blocks (non-generic) capturing type/trait pairing.
(impl_item
  trait: (type_identifier)? @trait
  type: (type_identifier) @rust_type
  (#set! "kind" "Class")) @symbol

; OVERRIDE impl blocks with generic type targets.
(impl_item
  trait: (type_identifier)? @trait
  type: (generic_type
    type: (type_identifier) @rust_type)
  (#set! "kind" "Class")) @symbol
