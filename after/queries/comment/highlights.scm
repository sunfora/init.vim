;; extend

((name) @Todo (#match? @Todo "^TODO$") (#set! "priority" 105))
((name) @Done (#match? @Done "^DONE$") (#set! "priority" 105))
((name) @Note (#match? @Note "^NOTE$") (#set! "priority" 105))
((name) @Usage (#match? @Usage "^USAGE$") (#set! "priority" 105))
((name) @Research (#match? @Research "^RESEARCH$") (#set! "priority" 105))
((name) @Canceled (#match? @Canceled "^CANCELED$") (#set! "priority" 105))
((name) @AiGen (#match? @AiGen "^AI_GENERATED$") (#set! "priority" 105))
((name) @CopyPaste (#match? @CopyPaste "^COPYPASTE$") (#set! "priority" 105))

((user) @Author (#set! "priority" 106))
