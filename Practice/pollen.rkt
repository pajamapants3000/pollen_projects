#lang racket/base
(require pollen/setup txexpr)
(provide (all-defined-out))

#| Module Definitions |#
(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html)))

#| Constant Definitions |#
(define depth 0)

#| Function Definitions |#

(define (root . content)
  (

  

; Create a section of text with a heading
;   heading depth is from 1 to 6, for h1-h6 in html
; (section depth "title" "content") - ◊section[depth "title"]{content}
(define
  (sectiona d t . content)
  (txexpr 'div '()
      `(,(txexpr
        (string->symbol (format "h~a" d))
        '()
        `(,t))
      ,@content)))

; IDEA: use macro on 'content' to convert "(section d t . content)" to
;   "(section (+ d 1) t . content)"
; Other idea: have separate 'section' (outermost) from 'subsection'
;   subsections leave 'depth and convert inside, section converts them and self
; Trying to get a closure for 'depth' (still!)
; WIP
(define section2a
  (lambda (d t . content)
    (let ([depth (+ d 1)])
      (txexpr 'div '()
          `(,(txexpr
            (string->symbol (format "h~a" depth))
            '()
            `(,t))
          ,@content)))))

; WIP
(define
  (section t . content)
    (parameterize (depth (+ depth 1))
      (txexpr 'div '()
          `(,(txexpr
            (string->symbol (format "h~a" depth))
            '()
            `(,t))
          ,@content))))

;WIP
(define
  (chapter t . content)
  (parameterize (depth 1)
    (txexpr 'div '()
        `(,(txexpr
          (string->symbol (format "h~a" depth))
          '()
          `(,t))
        ,@content))))

; Trying to get a closure for 'depth'
; WIP
(define
  (section3 d t . content)
  (lambda (_d _t . _content)
    (txexpr 'div '()
        `(,(txexpr
          (string->symbol (format "h~a" _d))
          '()
          `(,_t))
        ,@_content)))
  d t content)

#| Other Definitions |#

