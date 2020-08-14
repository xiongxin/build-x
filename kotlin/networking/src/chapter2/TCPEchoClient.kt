package chapter2

import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import java.net.ServerSocket
import java.net.Socket

fun main() {
  val clientSocket = Socket("localhost", 12000)
  val writer = PrintWriter(clientSocket.getOutputStream(), true)
  val reader = BufferedReader(InputStreamReader(clientSocket.getInputStream()))

  writer.println("hello server");
  println("都到服务端数据 => ${reader.readLine()}")

  clientSocket.close()
}