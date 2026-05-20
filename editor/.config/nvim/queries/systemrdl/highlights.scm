(boolean_literal) @constant.builtin
(string_literal) @string
(number) @number

(comment) @comment

[
  (unary_operator)
  (binary_operator)
] @operator

[
  (data_type)
] @type

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
  (id) @property.definition)

(enumerator_literal
  (id) @type
  (id) @constant)

(component_named_def
  id: (id) @type.definition)
(explicit_component_inst
  id: (id) @variable)
(component_inst
  id: (id) @variable)

(template) @embedded

[
  "abstract"
  "addrmap"
  "alias"
  "component"
  "constraint"
  "default"
  "enum"
  "external"
  "field"
  "inside"
  "internal"
  "mem"
  "property"
  "ref"
  "reg"
  "regfile"
  "signal"
  "struct"
  "this"
  "type"
] @keyword

[
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  ";"
  ":"
] @punctuation.delimiter

[
  "="
  "->"
] @operator
