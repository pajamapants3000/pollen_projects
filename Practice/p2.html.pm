#lang pollen

◊(define depth 1)

◊;◊(◊section2[ "My Section2" ]{
◊;    The body of "My Section2", thank you.
◊;    (That's right, see ya!)
◊;} depth)

◊section[◊depth "My Section" ]{
    The body of "My Section", thank you.
    (You're welcome... bye!)
    ◊section[◊depth "Inner Section" ]{
        Here's another section
    }
}


