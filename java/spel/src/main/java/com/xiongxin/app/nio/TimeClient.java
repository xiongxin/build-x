package com.xiongxin.app.nio;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.channels.DatagramChannel;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class TimeClient {
    private static final int DEFAULT_TIME_PORT = 37;
    private static final long DIFF_1900 = 2208988800L;
    protected int port = DEFAULT_TIME_PORT;
    protected List<SocketAddress> remoteHosts;
    protected DatagramChannel channel;

    public TimeClient(String[] argv) throws IOException {
        parseArgs(argv);
        this.channel = DatagramChannel.open();
    }

    protected InetSocketAddress receivePacket(DatagramChannel channel, ByteBuffer buffer) throws IOException {
        buffer.clear();

        // Receive an unsigned 32-bit, big-endian value
        return ((InetSocketAddress) channel.receive(buffer));
    }

    // Send time requests to all the supplied hosts
    protected void sendRequests() throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(1);
        Iterator it = remoteHosts.iterator();

        while (it.hasNext()) {
            InetSocketAddress sa = (InetSocketAddress) it.next();
            System.out.println("Requesting time from " + sa.getHostName() + ":" + sa.getPort());

            // Make it empty (see RFC868)
            buffer.clear().flip();
            // Fire and forget
            channel.send(buffer, sa);
        }
    }

    // Receive any replies that arrive
    public void getReplies() throws Exception {
        // Allocate a buffer to hold a long value
        ByteBuffer longBuffer = ByteBuffer.allocate(8);
        // Assure big-endian (network) byte order
        longBuffer.order(ByteOrder.BIG_ENDIAN);
        // Zero the whole buffer to be sure
        longBuffer.putLong(0, 0);
        // Position to first byte of the low-order 32 bits
        longBuffer.position(4);

        // Slice the buffer; gives view of the low-order 32 bits
        ByteBuffer buffer = longBuffer.slice();
        int expect = remoteHosts.size();
        int replies = 0;

    }

    protected void parseArgs(String[] argv) {
        this.remoteHosts = new LinkedList<>();

        InetSocketAddress sa = new InetSocketAddress("localhost", 9999);
        this.remoteHosts.add(sa);
    }
}
