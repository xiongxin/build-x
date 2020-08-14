package chapter2

import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import java.net.ServerSocket

fun main() {
  val serverSocket = ServerSocket(12000)
  val clientSocket = serverSocket.accept()
  val writer = PrintWriter(clientSocket.getOutputStream())
  val reader = BufferedReader(InputStreamReader(clientSocket.getInputStream()))
  val greeting = reader.readLine()
  println("收到客户端${clientSocket.port}: $greeting")
  if ("hello server".equals(greeting)) {
    writer.println("hello client")
  } else {
    writer.println("unrecognised greeting")
  }


  reader.close()
  writer.close()
  clientSocket.close()
  serverSocket.close()
}