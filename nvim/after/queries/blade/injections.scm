; =========================
; Blade PHP Injections
; =========================

; Inyectar PHP dentro de nodos de texto que no sean directivas
((text) @injection.content
  (#not-has-ancestor? @injection.content "directive")
  (#set! injection.combined)
  (#set! injection.language php))

; Inyectar PHP dentro de interpolaciones
((interpolation) @injection.content
  (#set! injection.language php)
  (#set! injection.combined))

((raw_expression) @injection.content
  (#set! injection.language php)
  (#set! injection.combined))

