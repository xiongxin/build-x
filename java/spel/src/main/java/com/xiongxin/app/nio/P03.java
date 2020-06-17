package com.xiongxin.app.nio;

import com.xiongxin.app.io.FileUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class P03 {

    public static void main(String[] args) {
        // The input file to read from
        File inputFile = new File("luci1.txt");

        // Make sure the input file exists
        if (!inputFile.exists()) {
            return;
        }

        // Obtain channel for luci1.txt file to read from it
        try (FileChannel fileChannel
                = new FileInputStream(inputFile).getChannel()) {

            // Create a buffer
            ByteBuffer buffer = ByteBuffer.allocate(1024);
            // Read all data from the channel
            while (fileChannel.read(buffer) > 0) {
                // Flip the buffer before we can read data from it
                buffer.flip();

                // Display the read data as characters on the console
                // Note that we are assuming that a byte represent a
                // character, which is not true all the time. In a
                // real world application, you should use
                // CharsetDecoder to decode the bytes into character
                // before you display/use them.
                while (buffer.hasRemaining()) {
                    byte b = buffer.get();

                    // Assuming a byte represent a character
                    System.out.print((char) b);
                }

                // clear the buffer before next read into it
                buffer.clear();
            }

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg("ll");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
