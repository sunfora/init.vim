([
  (string)
  (raw_string)
  (heredoc_body)
] @string)

([
  (heredoc_start)
  (heredoc_end)
] @punctuation)

((command_name) @function.call)

((declaration_command) @keyword.modifier)

((number) @number)

((variable_name) @variable)

(variable_assignment
  "=" @punctuation.delimiter)

([
  "case"
  "do"
  "done"
  "elif"
  "else"
  "esac"
  "export"
  "fi"
  "for"
  "function"
  "if"
  "in"
  "select"
  "then"
  "unset"
  "until"
  "while"
] @keyword)

((comment) @comment)

(function_definition name: (word) @function)

((file_descriptor) @number)

([
  (command_substitution)
  (process_substitution)
  (expansion)
] @embedded)

(compound_statement
  "{" @punctuation
  "}" @punctuation)
(command_substitution
  "$(" @punctuation
  ")"  @punctuation)
(process_substitution
  "<(" @punctuation
  ")"  @punctuation)
(command_substitution
  "`" @punctuation
  "`" @punctuation)
(simple_expansion
  "$" @punctuation)

([
  "&&"
  ">"
  ">>"
  "<"
  "|"
] @operator)

(command
  argument: ((word) @constant
    (#not-match? @constant "^-")))
(command
  argument: ((word) @property
    (#match? @property "^-")))
