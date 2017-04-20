#lang pollen
<!DOCTYPE html>
<html>
<head>
◊; create a variable `inside` that holds the value 2
◊(define inside 2)
◊; create a variable `edge` that's four times the value of `inside`
◊(define edge (* inside 4))
◊; create a variable `color` that holds the value "blue"
◊(define color "blue")
<style type="text/css">
pre {
    margin: ◊|edge|em;
    border: ◊|inside|em solid ◊|color|;
    padding: ◊|inside|em;
}
</style>
</head>
<body>
<pre>
The margin is ◊|edge|em.
The border is ◊|color|.
The padding is ◊|inside|em.
The border is too.
</pre>
</body>
</html>

