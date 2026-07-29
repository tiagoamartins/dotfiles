;; SystemRDL indentation query patterns for Tree-sitter in Neovim.
;; Configures indent behavior for blocks, braces, comments, and strings.

[
  (component_body)
  (struct_body)
  (constraint_body)
  (enum_body)
  (enum_property_assignment)
  (property_definition)
  (struct_literal)
  (array_literal)
  (constant_concatenation)
] @indent.begin

"}" @indent.branch

((param_def) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

((param_inst) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

(comment) @indent.auto

(string_literal) @indent.ignore
