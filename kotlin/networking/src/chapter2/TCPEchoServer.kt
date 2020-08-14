package chapter2

import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import java.net.ServerSocket
import java.net.Socket

class EchoClientHandler(val clientSocket : Socket) : Thread() {
  private val writer = PrintWriter(clientSocket.getOutputStream())
  private val reader = BufferedReader(InputStreamReader(clientSocket.getInputStream()))

  override fun run() {
    var inputLine:String? = null

    do {
      inputLine = reader.readLine()
      println("来自客户端 ${clientSocket.localAddress}:${clientSocket.port} => $inputLine")
      if ("." == inputLine) {
        writer.println("bye");break
      }
      writer.println(inputLine)
      writer.flush()
    } while ( inputLine != null )
  }
}

fun main() {
  val serverSocket = ServerSocket(12000)
  while (true)
    EchoClientHandler(serverSocket.accept()).start()
}