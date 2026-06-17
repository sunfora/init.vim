(require_expression) @keyword.import

[(encapsed_string) 
 (string) 
 (string_content)] @string
(echo_statement) @function.builtin
(php_tag) @tag

((text_interpolation) @tag
  (#match? @tag "^?>"))

(scoped_call_expression
  name: (name) @function.call)
(scoped_call_expression
  scope: (name) @type)

(function_call_expression
  function: (name) @function.call)
(function_call_expression
  function: (qualified_name) @function.call)
(qualified_name
  "\\" @punctuation.delimiter) 

(member_call_expression
  name: (name) @function.method.call)

[
 "extends"
 "implements"
 "namespace"
] @keyword

[
 "class"
 "enum"
] @keyword.type

[
 "return"
] @keyword.return

[
  "if" 
  "else" 
  "switch" 
  "case" 
  "match"
  "default"
] @keyword.conditional

[
  "foreach" 
  "while"
  "for"
  "break"
  "continue"
] @keyword.repeat

[
 "function"
] @keyword.function

[
  "->"
  "==="
  "$"
] @operator

((comment) @comment)

((variable_name) @variable)

(namespace_name) @module

((_) @constant.builtin
 (#any-of? @constant.builtin 

   "E_ALL" 
   "E_ERROR" 
   "E_WARNING" 
   "E_PARSE" 
   "E_NOTICE" 
   "E_STRICT"

   "__DIR__"
  
   "ENT_HTML5"
   ))

((_) @variable.builtin
 (#any-of? @variable.builtin 
  "$_SERVER" 
  "$_GET" 
  "$_POST" 
  "$_SESSION"))

;; types 
(named_type) @type

;; Arguments 
(simple_parameter
  (variable_name) @variable.parameter)

((cast_type) @type.builtin 
  (#any-of? @type.builtin
   "int" 
   "integer"
   
   "bool"
   "boolean"
   
   "float"
   "double"
   "real"
    
   "string"

   "array"

   "object"

   "void"
   ))

(class_declaration
  name: (name) @type.definition)
(enum_declaration
  name: (name) @type.definition)
(enum_case
  name: (name) @type.definition)

(class_declaration
  (base_clause
    (qualified_name
      (name) @type)))

;; Numbers
(integer) @number

;; Booleans

(boolean) @boolean

;; enums

(class_constant_access_expression 
  (name) @constant)

(visibility_modifier) @keyword.modifier
(static_modifier) @keyword.modifier
(primitive_type) @type.builtin

(class_interface_clause
  (qualified_name
    (name) @type))

(method_declaration
  name: (name) @function.method)

(heredoc_start) @label
(heredoc_end) @label
