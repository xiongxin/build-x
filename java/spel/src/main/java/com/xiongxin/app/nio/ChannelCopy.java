package com.xiongxin.app.nio;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

public class ChannelCopy {

    public static void main(String[] args) throws IOException {

        ReadableByteChannel source = Channels.newChannel(new FileInputStream("luci1.txt"));
        WritableByteChannel dest = Channels.newChannel(System.out);

        channelCopy2(source, dest);

        source.close();
        dest.close();

    }

    private static void channelCopy1(ReadableByteChannel src,
                                     WritableByteChannel dest) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocateDirect(1024);

        while (src.read(buffer) != -1) {
            // Prepare the buffer to be drained
            buffer.flip();

            // write to the channel; my block
            dest.write(buffer);
            // if Partial transfer, shift reminder down
            // if buffer is empty, same as dong clear()
            buffer.compact();
        }

        // EOF will leave buffer in fill state
        buffer.flip();

        // Make sure that the buffer is fully drained
        while (buffer.hasRemaining()) {
            dest.write(buffer);
        }
    }

    private static void channelCopy2(ReadableByteChannel src,
                                     WritableByteChannel dest) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocateDirect(1024);

        while (src.read(buffer) > 0) {
            buffer.flip();
            while (buffer.hasRemaining()) {
                dest.write(buffer);
            }
            buffer.clear();
        }
    }
}
