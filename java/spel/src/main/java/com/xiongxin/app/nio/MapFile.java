package com.xiongxin.app.nio;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * @author Ron Hitchens (ron@ronsoft.com)
 */
public class MapFile {

    public static void main(String[] args) throws IOException {
        // Create a temp file and get a channel connected to it
        File tempFile = File.createTempFile("mmaptest", null);
        RandomAccessFile file = new RandomAccessFile(tempFile, "rw");
        FileChannel channel = file.getChannel();
        ByteBuffer temp = ByteBuffer.allocate(100);

        // Put something in the file, starting at location 0
        temp.put("This is the file content".getBytes());
        temp.flip();
        channel.write(temp, 0);

        // Put something else in the file, starting at location 8192.
        // 8192 is 8kb, almost certainly a different memory/FS page.
        // This may cause a file hole, depending on the
        // filesystem page size
        temp.clear();
        temp.put("This is more file content".getBytes());
        temp.flip();
        channel.write(temp, 8192); // 从8K位置写入文件

        // Create three types of mapping to the same file
        MappedByteBuffer ro = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
        MappedByteBuffer rw = channel.map(FileChannel.MapMode.READ_WRITE, 0, channel.size());
        MappedByteBuffer cow = channel.map(FileChannel.MapMode.PRIVATE, 0, channel.size());

        // the buffer states before any modifications
        System.out.println("beigin");
        showBuffers(ro, rw, cow);

        // Modify the copy-on-write buffer
        cow.position(8);
        cow.put("COW".getBytes());
        System.out.println("Change to COW buffer");
        showBuffers(ro, rw, cow);

        // Modify the read/write buffer
        rw.position (9);
        rw.put (" R/W ".getBytes( ));
        rw.position (8194);
        rw.put (" R/W ".getBytes( ));
        rw.force( );
        System.out.println("Change to R/W buffer");
        showBuffers(ro, rw, cow);

        // Write to the file through the channel; hit both pages
        temp.clear();
        temp.put("Channel write " .getBytes());
        temp.flip();
        channel.write(temp, 0);
        temp.rewind();
        channel.write(temp, 8202);
        System.out.println ("Write on channel");
        showBuffers (ro, rw, cow);

        // Modify the read/write buffer
        rw.position (0);
        rw.put (" R/W2 ".getBytes( ));
        rw.position (8210);
        rw.put (" R/W2 ".getBytes( ));
        rw.force( );
        System.out.println ("Second change to R/W buffer");
        showBuffers (ro, rw, cow);

        // cleanup
        channel.close();
        file.close();
        tempFile.delete();
    }

    public static void showBuffers(ByteBuffer ro, ByteBuffer rw, ByteBuffer cow) {
        dumpBuffer("R/O", ro);
        dumpBuffer("R/W", rw);
        dumpBuffer("ROW", cow);
        System.out.println();
    }

    // Dump buffer content, counting and skipping nulls
    private static void dumpBuffer(String prefix, ByteBuffer buffer) {
        System.out.print(prefix + ": '");

        int nulls = 0;
        int limit = buffer.limit();

        for (int i = 0; i < limit; i++) {
            char c = (char) buffer.get(i);

            if (c == '\u0000') {
                nulls++;
                continue;
            }

            if (nulls != 0) {
                System.out.print("|[" + nulls + " nulls]|");
                nulls = 0;
            }

            System.out.print(c);
        }

        System.out.println("'");
    }
}
