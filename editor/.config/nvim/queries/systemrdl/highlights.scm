(boolean_literal) @boolean
(string_literal) @string
(number) @number

(comment) @comment

(unary_operator) @operator
(binary_operator) @operator

[
  "="
  "->"
] @operator

[
  (integer_atom_type)
  (integer_vector_type)
  "string"
  "boolean"
  "accesstype"
  "addressingtype"
  "onreadtype"
  "onwritetype"
] @type.builtin

(data_type) @type

(prop_keyword) @property
(prop_ref
  (instance_ref) @variable
  (prop_keyword) @property)
(prop_ref
  (instance_ref) @variable
  (id) @property)
(explicit_prop_assignment
  LHS: (prop_assignment_lhs
    (id) @property))
(explicit_prop_assignment
  LHS: (prop_assignment_lhs
    (prop_keyword) @property))
(property_definition
  (id) @property)

(enumerator_literal
  (id) @type
  (id) @constant)

(component_named_def
  id: (id) @type.definition)
(explicit_component_inst
  id: (id) @variable)
(component_inst
  id: (id) @variable)

"this" @variable.builtin

[
  "abstract"
  "external"
  "internal"
] @keyword.modifier

[
  "addrmap"
  "constraint"
  "enum"
  "field"
  "mem"
  "property"
  "reg"
  "regfile"
  "signal"
  "struct"
] @keyword.type

"inside" @keyword.operator

[
  "alias"
  "component"
  "default"
  "ref"
  "type"
] @keyword

[
  "{"
  "}"
  "["
  "]"
  "("
  ")"
] @punctuation.bracket

[
  ";"
  ":"
  ","
  "."
] @punctuation.delimiter

(accesstype_literal) @constant.builtin
(onreadtype_literal) @constant.builtin
(onwritetype_literal) @constant.builtin
(addressingtype_literal) @constant.builtin
(precedencetype_literal) @constant.builtin
