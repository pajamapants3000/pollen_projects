#lang racket

(module mymod racket

  (require txexpr)

  (struct mypref (d t strlist) #:prefab )
  
  (define (chapter . etc)
    (txexpr 'div '()
            (show-inner etc)))

  (define (show-inner inner)
    (for/list ([word inner])
      (cond
        [(mypref? word) (txexpr 'div '()
                                (cons
                                 (txexpr
                                  (string->symbol (format "h~a" (mypref-d word)))
                                  '()
                                  `(,(mypref-t word)))
                                 (show-inner (mypref-strlist word))))]
        [else word])))

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

  (define (update-inner inner)
    (for/list ([word (flatten inner)])
      (cond
        [(mypref? word) (mypref
                         (+ (mypref-d word) 1)
                         (mypref-t word)
                         (update-inner (mypref-strlist word)))]
        [else word])))

  (provide section update-inner show-inner)
  (provide
   (contract-out
    [chapter (->* () #:rest (listof any/c) any)])))


(require 'mymod)

(display (chapter (section "title1" (section "title2" "test2") "test") "this"))
