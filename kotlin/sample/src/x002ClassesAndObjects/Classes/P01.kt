package x002ClassesAndObjects.Classes

class Person(val name: String) {
  var children = mutableListOf<Person>()

  constructor(name: String, parent: Person) : this(name) {
    parent.children.add(this)
  }
}