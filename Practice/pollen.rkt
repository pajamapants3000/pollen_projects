#lang racket/base
(require pollen/setup)
(provide (all-defined-out))

(module setup racket/base
    (provide (all-defined-out))
    (define poly-targets '(html)))

; Display list of strings as unordered list
(define
  (ul-list ul-items)
  ('ul
    (map
      (lambda (item)
        (li item)
      )
      ul-items
    )
  )
)

