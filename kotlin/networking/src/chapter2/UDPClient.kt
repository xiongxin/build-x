package chapter2

import java.net.*


fun main() {
  val socket = DatagramSocket()
  val address = InetAddress.getByName("localhost")

  val byteArray = "q".toByteArray()

  var packet = DatagramPacket(byteArray, byteArray.size, address, 12000)
  socket.send(packet)
  packet = DatagramPacket(byteArray, byteArray.size)
  socket.receive(packet)
  val received = String(packet.data, 0, packet.data.size)

  println(received)
}