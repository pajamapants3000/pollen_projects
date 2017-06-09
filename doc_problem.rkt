#lang racket

(module mymod racket

  (require txexpr)

  (struct mypref (d t strlist) #:prefab )
  
  (define (chapter . etc)
     (show-inner etc))

  (define (show-inner inner)
    (string-join
     (for/list ([word (flatten inner)])
       (cond
         [(mypref? word) (format "~a\n'The number is ~a'\n~a"
                                 (mypref-t word)
                                 (+ (mypref-d word) 0)
                                 (show-inner (mypref-strlist word)))]
         [else word]))))

 (define (section t . etc)
   (mypref
       1
       t
       (for/list ([word (flatten etc)])
         (cond
           [(mypref? word) (mypref
                            (+ (mypref-d word) 1)
                            (mypref-t word)
                            (update-inner (mypref-strlist word)))]
           [else word]))))
#|
 (define (section t . etc)
   (mypref
       1
       t
       words
       (UpdateInner inner)
|#
  (define (update-inner inner)
    (for/list ([word (flatten inner)])
      (cond
        [(mypref? word) (mypref
                         (+ (mypref-d word) 1)
                         (mypref-t word)
                         (update-inner (mypref-strlist word)))]
        [else word])))


(define
  (make-section d t . content)
  (txexpr 'div '()
      `(,(txexpr
        (string->symbol (format "h~a" d))
        '()
        `(,t))
      ,@content)))    
    
(provide section make-section update-inner show-inner)
(provide
 (contract-out
  [chapter (->* () #:rest (listof any/c) any)])))


(require 'mymod)

(display (chapter (section "title1" (section "title2" "test2") "test") "this"))
