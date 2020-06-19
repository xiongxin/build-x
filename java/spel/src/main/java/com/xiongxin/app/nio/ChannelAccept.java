package com.xiongxin.app.nio;


import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;

public class ChannelAccept {
    public static final String GREETING = "Hello I must be going.\r\n";

    public static void main(String[] args) throws IOException, InterruptedException {
        ByteBuffer buffer = ByteBuffer.wrap(GREETING.getBytes());
        ServerSocketChannel ssc = ServerSocketChannel.open();

        ssc.socket().bind(new InetSocketAddress(1234));
        ssc.configureBlocking(false);

        while (true) {
            System.out.println("Waiting for connections");

            SocketChannel sc = ssc.accept();

            if (sc == null) {
                // no connections, snooze a while
                Thread.sleep(2000);
            } else {
                System.out.println("Incoming connection from: "
                    + sc.socket().getRemoteSocketAddress());

                buffer.rewind();
                sc.write(buffer);
                sc.close();
            }
        }
    }
}
