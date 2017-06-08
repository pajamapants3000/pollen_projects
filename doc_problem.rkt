#lang racket

(module mymod racket
(define (myfunc x . etc)
  (string-join
    (list
      (format "'The number is ~a'" (+ 1 x))
      (string-join etc))))

(define (myfunc2 . etc)
  (string-join
    (list
      (format "'The number is ~a'" 2)
      (string-join etc))))

(provide myfunc2)
(provide
 (contract-out
  [myfunc (->* (integer?) #:rest (listof any/c) any)])))


(require 'mymod)

(display (myfunc2 "let's" (myfunc2 "test") "this"))

(define mypref #s(this 1 2))
(struct this (x y) #:prefab)
