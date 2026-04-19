;; NOTE: We override (rather than extend) the upstream query so we can replace
;; several patterns with richer captures without producing duplicate symbols.
;; Parent/child nesting is handled by aerial via AST containment, so nested
;; patterns (e.g. consts inside traits/impls) are unnecessary — a top-level
;; pattern matches them anywhere in the tree and they nest automatically.

; Module declarations (`mod foo;` / inline modules).
(mod_item
  name: (identifier) @name
  (#set! "kind" "Module")) @symbol

; Enum declarations.
(enum_item
  name: (type_identifier) @name
  (#set! "kind" "Enum")) @symbol

; Enum variants — nest under their enum via AST containment.
(enum_variant
  name: (identifier) @name
  (#set! "kind" "EnumMember")) @symbol

; Struct declarations.
(struct_item
  name: (type_identifier) @name
  (#set! "kind" "Struct")) @symbol

; Unions (presented like structs).
(union_item
  name: (type_identifier) @name
  (#set! "kind" "Struct")) @symbol

; Struct / union fields.
(field_declaration
  name: (field_identifier) @name
  (#set! "kind" "Field")) @symbol

; Trait declarations.
(trait_item
  name: (type_identifier) @name
  (#set! "kind" "Interface")) @symbol

; Type aliases (`type Foo = Bar;`). Nested associated types under trait/impl
; bodies are captured by the same pattern.
(type_item
  name: (type_identifier) @name
  (#set! "kind" "TypeParameter")) @symbol

; `macro_rules!` definitions.
(macro_definition
  name: (identifier) @name
  (#set! "kind" "Function")) @symbol

; `const` items (top-level and associated — associated consts nest via AST
; containment, no separate pattern needed).
(const_item
  name: (identifier) @name
  (#set! "kind" "Constant")) @symbol

; `static` items.
(static_item
  name: (identifier) @name
  (#set! "kind" "Constant")) @symbol

; Functions with explicit return type (capture generics / params / return).
(function_item
  name: (identifier) @name
  type_parameters: (type_parameters)? @rust_generics
  parameters: (parameters) @rust_params
  return_type: (_) @rust_return
  (#set! "kind" "Function")) @symbol

; Functions without explicit return type.
(function_item
  name: (identifier) @name
  type_parameters: (type_parameters)? @rust_generics
  parameters: (parameters) @rust_params
  (#set! "kind" "Function")) @symbol

; Trait method signatures with explicit return type.
(function_signature_item
  name: (identifier) @name
  type_parameters: (type_parameters)? @rust_generics
  parameters: (parameters) @rust_params
  return_type: (_) @rust_return
  (#set! "kind" "Function")) @symbol

; Trait method signatures without explicit return type.
(function_signature_item
  name: (identifier) @name
  type_parameters: (type_parameters)? @rust_generics
  parameters: (parameters) @rust_params
  (#set! "kind" "Function")) @symbol

; Impl blocks. `(_)` wildcards cover scoped (`std::ops::Add`), generic
; (`From<T>`), reference, and tuple type/trait forms — `rust_impl_label`
; reads the captured source text verbatim.
(impl_item
  trait: (_)? @trait
  type: (_) @rust_type
  (#set! "kind" "Class")) @symbol
