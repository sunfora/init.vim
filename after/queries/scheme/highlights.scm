((comment) @comment)

((keyword) @property)

((symbol) @function.builtin
 (#any-of? @function.builtin
  "list"
   ))

((symbol) @keyword.conditional 
  (#any-of? @keyword.conditional
    "if"
    "cond"
    "case"
    "and"
    "or"
   ))

((symbol) @constant
 (#match? @constant "^[%]"))

((symbol) @keyword
  (#any-of? @keyword
    "define"
    "let"
    "let*"
    "define-public"
   ))

((symbol) @keyword.function
  (#any-of? @keyword.function
    "lambda"
    "lambda*"
   ))

((symbol) @keyword.import
 (#any-of? @keyword.import 
  "define-module"
  "use-modules" 
  "export"
  "import"))

((string) @string)
((number) @number)

((symbol) @keyword.coroutine
 (#any-of? @keyword.coroutine 
  "delay"
  "force"))
