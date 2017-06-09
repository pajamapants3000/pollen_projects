#lang racket
(require pollen/setup txexpr)

#| Module Definitions |#
(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html)))

#| Constant Definitions |#

#| Function Definitions |#

(struct depth (d t strlist) #:prefab)
  
(define (chapter t . etc)
  (string-join
    (list
      t
      (string-join
        (for/list ([word (flatten etc)])
          (cond
            [(depth? word) (makesection
                             (+ (depth-d word) 0)
                             (depth-t word)
                             (string-join (eval (depth-strlist word))))]
            [else word]))))))

(define (section t . etc)
  (list
    '#s(depth
         1
         t
         (for/list ([word (flatten etc)])
           (cond
             [(depth? word) (depth
                              (+ (depth-d word) 1)
                              (depth-t word)
                              (depth-strlist word))]
             [else word])))))

(provide
 (contract-out
  [chapter (->* (string?) #:rest (listof any/c) any)])) 
(provide
 (contract-out
  [section (->* (string?) #:rest (listof any/c) any)])) 
(provide makesection)

; Create a section of text with a heading
;   heading depth is from 1 to 6, for h1-h6 in html
; (section depth "title" "content") - ◊section[depth "title"]{content}
(define
  (makesection d t . content)
  (txexpr 'div '()
      `(,(txexpr
        (string->symbol (format "h~a" d))
        '()
        `(,t))
      ,@content)))

#|
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

;WIP
(define
  (chapterx t . content)
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
|#
#| Other Definitions |#

