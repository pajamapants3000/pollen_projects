#lang racket/base
(require pollen/setup txexpr)
(provide (all-defined-out))

#| Module Definitions |#
(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html)))

#| Function Definitions |#
; Generate series of list items from list of strings, to use in ol or ul
(define
  (li-items items)
  (map
    (lambda (item)
      (txexpr 'li '() `(,item)))
    items))
; Display list of strings as unordered list
(define
  (ul-list ul-items)
  (txexpr 'ul '() (li-items ul-items)))

; Display list of strings as ordered list
(define
  (ol-list ol-items)
  (txexpr 'ol '() (li-items ol-items)))

#| Other Definitions |#

