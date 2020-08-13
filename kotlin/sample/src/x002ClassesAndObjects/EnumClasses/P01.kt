package x002ClassesAndObjects.EnumClasses

import java.util.function.BinaryOperator
import java.util.function.IntBinaryOperator

enum class Color(val rgb: Int) {
  RED(0x1),
  GREEN(0x2),
  BLUE(0x3)
}


enum class ProtocolState {
  WAITING {
    override fun signal(): ProtocolState = TALKING
  },
  TALKING {
    override fun signal(): ProtocolState = WAITING
  };

  abstract fun signal() : ProtocolState
}

enum class IntArithmetics : BinaryOperator<Int>, IntBinaryOperator {
  PLUS {
    override fun apply(t: Int, u: Int) = t + u
  },
  TIMES {
    override fun apply(t: Int, u: Int) = t * u
  };

  override fun applyAsInt(left: Int, right: Int)  = apply(left, right)
}

fun main() {

  val w = "WAITING"
  val p = ProtocolState.valueOf(w).signal()
  println(p)

  println(IntArithmetics.PLUS.apply(1, 2))
  println(IntArithmetics.PLUS.applyAsInt(1, 2))

  IntArithmetics.values().forEach(::println)
  println(enumValueOf<ProtocolState>(w))
  println(enumValues<ProtocolState>().joinToString())
}