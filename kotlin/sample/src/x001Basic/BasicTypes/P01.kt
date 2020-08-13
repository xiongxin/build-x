package x001Basic.BasicTypes

fun main() {
  fun printDouble(d: Double) { println(d) }

  val d = 1.1
  printDouble(d)

  val a: Int = 100
  val boxedA: Int? = a
  val anotherBoxedA: Int? = a

  val b: Int = 10000
  val boxedB: Int? = b
  val anotherBoxedB: Int? = b

  println(boxedA === anotherBoxedA) // true
  println(boxedB === anotherBoxedB) // false

  val a1: Int? = null
  val b1: Long? = a.toLong()
  print(a1?.equals(b1))

  println(100 shr 1)
  println()

  val c = '\uFF00'
  println(c)
}