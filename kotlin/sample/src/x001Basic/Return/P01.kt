package x001Basic.Return

fun foo() {
  listOf(1, 2, 3, 4, 5).forEach {
    if (it == 3) return@forEach
    print(it)
  }
}

