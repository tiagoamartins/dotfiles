;; SystemRDL local scoping, definitions, and references query patterns for Tree-sitter in Neovim.
;; Enables code navigation, definition lookup, and occurrences highlighting.

;; Block scopes
(component_body) @local.scope
(struct_body) @local.scope
(constraint_body) @local.scope
(enum_body) @local.scope
(enum_property_assignment) @local.scope
(property_definition) @local.scope

;; Definitions
(component_named_def id: (id) @local.definition.type)
(struct_def (id) @local.definition.type)
(constraint_def_exp (id) @local.definition.type)
(enum_def (id) @local.definition.type)
(property_definition (id) @local.definition.property)
(component_inst id: (id) @local.definition.field)
(struct_elem (id) @local.definition.field)
(enum_entry (id) @local.definition.constant)
(param_def_elem (id) @local.definition.parameter)

;; References
(id) @local.reference
