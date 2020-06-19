package com.xiongxin.app.nio;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.WritableByteChannel;

public class ChannelTransfer {

    public static void main(String[] args) throws IOException {
        catFiles(Channels.newChannel(System.out), new String[]{"/home/xiongxin/Code/build-x/java/spel/src/main/java/com/xiongxin/app/nio/ChannelTransfer.java"});
    }

    // Concatenate the content of each of the named files to
    // the given channel. A very dumb version of 'cat'.
    private static void catFiles(WritableByteChannel target, String[] files) throws IOException {
        for (int i = 0; i < files.length; i++) {
            FileInputStream fis = new FileInputStream(files[i]);
            FileChannel channel = fis.getChannel();

            channel.transferTo(0, channel.size(), target);

            channel.close();
            fis.close();
        }
    }
}
