#lang racket

(require pollen/setup txexpr)

#| Module Definitions |#
(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html txt ltx pdf)))

#| Constant Definitions |#
(define latex-font-sizes #("Huge" "huge" "LARGE" "Large" "large" "normalsize"))

#| Function Definitions |#

(struct depth (d t strlist) #:prefab)
(define-namespace-anchor nsa)
(define ns (namespace-anchor->namespace nsa))

(define (chapter . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append (show-inner etc ""))]
    [(txt) (txexpr 'div '() (show-inner etc ""))]
    [(html) (txexpr 'div '() (show-inner etc ""))]))

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
  (show-inner inner parentnum)
  (case (current-poly-target)
    [(ltx pdf txt)
        (let ([count 0])
            (for/list ([word inner])
              (cond
                [(depth? word)
                  (set! count (add1 count))
                  (let ([mynum (string-append
                            parentnum
                            (if (non-empty-string? parentnum) "." "")
                            (number->string count))])
                    (apply string-append
                      (eval (read (open-input-string (string-append
                          (format "(heading ~a \"~a - "
                            (if (> (depth-d word) 6) 6 (depth-d word)) mynum)
                          (depth-t word) "\")"))) ns)
                      (show-inner (depth-strlist word) mynum)))]
                [else word])))]

    [(html)
     (let ([count 0])
    (for/list ([word inner])
        (cond
          [(depth? word)
           (set! count (add1 count))
           (let ([mynum (string-append
                          parentnum
                          (if (non-empty-string? parentnum) "." "")
                          (number->string count))])
           (txexpr 'div '()
            (cons
              (eval (read (open-input-string (string-append
               (format "(heading ~a \"~a - "
                (if (> (depth-d word) 6) 6 (depth-d word)) mynum)
              (depth-t word) "\")"))) ns)
             (show-inner (depth-strlist word) mynum))))]
          [else word])))]))

(define (update-inner inner)
  (for/list ([word inner])
    (cond
      [(depth? word) (depth
                       (+ (depth-d word) 1)
                       (depth-t word)
                       (update-inner (depth-strlist word)))]
      [else word])))

(define (heading d . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\"
                                      ,(vector-ref latex-font-sizes d)
                                      " "
                                      ,@etc
                                      "}\\\\"))]
    [(txt) (apply string-append
                  (make-string d #\*)
                  (map string-upcase etc)
                  (make-string d #\*))]
    [(html) (txexpr (string->symbol (format "h~a" d)) '() `(,@etc))]))

(define (ollist . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("\\begin{enumerate} "
                                      ,@etc
                                      "\\end{enumerate}"))]
    [(txt) (apply string-append `(">>>"
                                  ,@etc
                                  ">>>\n"))]
    [(html) (txexpr 'ol '() `(,@etc))]))

(define (ullist . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("\\begin{itemize}"
                                      ,@etc
                                      "\\end{itemize}"))]
    [(txt) (etc)]
    [(html) (txexpr 'ul '() `(,@etc))]))

(define (listitem . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("\\item " ,@etc))]
    [(txt) (etc)]
    [(html) (txexpr 'li '() `(,@etc))]))

(define (makestrong . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bfseries " ,@etc "}"))]
    [(txt) (etc)]
    [(html) (txexpr 'strong '() `(,@etc))]))

(define (emphasize . etc)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\em " ,@etc "}"))]
    [(txt) (etc)]
    [(html) (txexpr 'em '() `(,@etc))]))

(provide
 (contract-out
  [chapter (->* () #:rest (listof any/c) any)]))
(provide
 (contract-out
  [section (->* (string?) #:rest (listof any/c) any)]))
(provide makestrong emphasize heading ullist ollist listitem)
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

