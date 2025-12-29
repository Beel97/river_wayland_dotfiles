; =========================
; Blade Highlights
; =========================


; Directivas Blade
(directive) @directive
(directive_start) @directive
(directive_end) @directive
(keyword) @directive

; Comentarios
(comment) @comment

; Brackets
((bracket_start) @punctuation.bracket (#set! "priority" 120))
((bracket_end) @punctuation.bracket (#set! "priority" 120))

; Variables {{ ... }}
((interpolation) @variable)
((raw_expression) @variable)

; Strings dentro de arrays y argumentos
((array_element) @string)
((argument_list (string) @string))
((argument_list (raw_string) @string))

