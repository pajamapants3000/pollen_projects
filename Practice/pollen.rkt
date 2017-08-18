#lang racket

(require pollen/setup txexpr)

#| Module Definitions |#
(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html txt ltx pdf)))

#| Constant Definitions |#

#| Function Definitions |#

(struct depth (d t strlist) #:prefab)

(define (chapter . etc)
  (case (current-poly-target)
    [(ltx pdf) (txexpr 'div '() (show-inner etc))]
    [(txt) (txexpr 'div '() (show-inner etc))]
    [else (txexpr 'div '() (show-inner etc))]))

(define (section t . etc)
    (depth
         1
         t
         (for/list ([word etc])
           (cond
             [(depth? word) (depth
                              (+ (depth-d word) 1)
                              (depth-t word)
                              (update-inner (depth-strlist word)))]
             [else word]))))

(define
  (show-inner inner)
  (case (current-poly-target)
    [(ltx pdf) (for/list ([word inner])
        (cond
          [(depth? word) (txexpr 'div '()
                                  (cons
                                   (txexpr
                                    (string->symbol (format "h~a" (depth-d word)))
                                    '()
                                    `(,(depth-t word)))
                                   (show-inner (depth-strlist word))))]
          [else word]))]
    [(txt) (for/list ([word inner])
        (cond
          [(depth? word) (txexpr 'div '()
                                  (cons
                                   (txexpr
                                    (string->symbol (format "h~a" (depth-d word)))
                                    '()
                                    `(,(depth-t word)))
                                   (show-inner (depth-strlist word))))]
          [else word]))]
    [else (for/list ([word inner])
        (cond
          [(depth? word) (txexpr 'div '()
                                  (cons
                                   (txexpr
                                    (string->symbol (format "h~a" (depth-d word)))
                                    '()
                                    `(,(depth-t word)))
                                   (show-inner (depth-strlist word))))]
          [else word]))]))

(define (update-inner inner)
  (for/list ([word inner])
    (cond
      [(depth? word) (depth
                       (+ (depth-d word) 1)
                       (depth-t word)
                       (update-inner (depth-strlist word)))]
      [else word])))

(provide
 (contract-out
  [chapter (->* () #:rest (listof any/c) any)]))
(provide
 (contract-out
  [section (->* (string?) #:rest (listof any/c) any)]))
(provide update-inner show-inner)

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

