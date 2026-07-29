;; SystemRDL folding query patterns for Tree-sitter in Neovim.
;; Enables folding of multi-line blocks and elements such as components,
;; structs, properties, constraints, enums, and comments.

(component_body) @fold
(property_definition) @fold
(struct_body) @fold
(constraint_body) @fold
(enum_body) @fold
(enum_property_assignment) @fold
(comment) @fold
