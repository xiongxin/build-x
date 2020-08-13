package x002ClassesAndObjects.SealedClasses

sealed class Expr

data class Const(val number: Double) : Expr()
data class Sum(val e1: Expr, val e2: Expr) : Expr()
object NotANumber : Expr()


fun main() {
  val nan = NotANumber
  val nan1= NotANumber

  println("$nan $nan1")
}