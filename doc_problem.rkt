#lang racket

(module mymod racket

  (struct mypref (d) #:prefab)
  
  (define (myfunc . etc)
    (string-join
     (for/list ([word (flatten etc)])
       (cond
         [(mypref? word) (format "'The number is ~a'" (+ (mypref-d word) 0))]
         [else word]))))

 (define (myfunc2 . etc)
    (list
     '#s(mypref 1)
      (for/list ([word (flatten etc)])
        (cond
          [(mypref? word) (mypref (+ (mypref-d word) 1))]
          [else word]))))
                      

(provide myfunc2)
(provide
 (contract-out
  [myfunc (->* () #:rest (listof any/c) any)])))


(require 'mymod)

(myfunc (myfunc2 (myfunc2 "test2") "test") "this")
