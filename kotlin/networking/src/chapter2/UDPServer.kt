package chapter2

import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetSocketAddress
import java.net.Socket

fun main() {
  val socket = DatagramSocket(12000)
  var running = true
  val buf = ByteArray(256)
  while (running) {
    var packet = DatagramPacket(buf, buf.size)
    socket.receive(packet)

    val address = packet.address; val port = packet.port
    packet = DatagramPacket(buf, buf.size, address, port)

    val received = String(packet.data, 0, packet.length)
    println("received data is: $received == q  ${received == "q"}")
    if (received == "q") {
      running = false
      continue
    }
    socket.send(packet)
  }

  socket.close()
}