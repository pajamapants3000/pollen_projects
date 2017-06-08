#lang racket

(module mymod racket

  (struct mypref (d) #:prefab)
  
  (define (myfunc x . etc)
    (string-join
      (list
        (format "'The number is ~a'" (+ 1 x))
        (string-join etc))))

(define (myfunc2 . etc)
  (for/list ([word etc])
    (cond
      [(mypref? word) #s(mypref (+ 1 (mypref-d word)))]
      [else word])))
                      

(provide myfunc2)
(provide
 (contract-out
  [myfunc (->* (integer?) #:rest (listof any/c) any)])))


(require 'mymod)

(display (myfunc2 "let's" (myfunc2 "test") "this"))
