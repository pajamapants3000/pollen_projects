#lang pollen

◊(define chapter 2)
◊(define depth 2)       ◊; WIP

◊(define ol-items
  (list
  "row one"
  "row two"
  "row three"))

◊h1{My List}
◊(section 1 "just testing" "This is just a test")
◊section[1 "1"]{
    section one
    ◊section[2 "1.1"]{
        section one-point-one
        ◊section[3 "1.1.1"]{
            section one-point-one-point-one
        }
    }
    ◊section[2 "1.2"]{
        section one-point-two
    }
}
