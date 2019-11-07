import asyncdispatch, os
type
    Person = ref object
        name: string
        age: int

var person: Person# = Person(name: "abc", age: 100)
echo isNil(person)
echo repr(person)

proc test(): Future[int] {.async.} =
    sleep(3000)
    result = 1

var feture = newFuture[int]()
feture.callback=
    proc (future: Future[int]) =
        echo "Get future value", future.read()

sleep(3000)

feture.complete(2)
