type
    Person = ref object
        name: string
        age: int

var person: Person# = Person(name: "abc", age: 100)
echo isNil(person)
echo repr(person)