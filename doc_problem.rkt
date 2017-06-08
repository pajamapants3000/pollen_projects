#lang racket

(module mymod racket

  (struct mypref (d) #:prefab)
  
  (define (myfunc x . etc)
    (string-join
     (for/list ([word (flatten etc)])
       (cond
         [(mypref? word) (format "'The number is ~a'" (+ (mypref-d word) x))]
         [else word]))))

 (define (myfunc2 . etc)
    (list
     '#s(mypref 1)
      (for/list ([word (flatten etc)])
        (cond
          [(mypref? word) #s(mypref (+ 1 (mypref-d word)))]
          [else word]))))
                      

(provide myfunc2)
(provide
 (contract-out
  [myfunc (->* (integer?) #:rest (listof any/c) any)])))


(require 'mymod)

(display (myfunc 3 "let's" (myfunc2 "test") "this"))
