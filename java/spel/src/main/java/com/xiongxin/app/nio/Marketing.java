package com.xiongxin.app.nio;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.channels.GatheringByteChannel;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * @author Ron Hitchens (ron@ronsoft.com)
 */
public class Marketing {
    private static final String DEMOGRAPHIC = "blahblah.txt";

    public static void main(String[] args) throws IOException {
        int reps = 10;

        FileOutputStream fos = new FileOutputStream(DEMOGRAPHIC);
        GatheringByteChannel gatheringByteChannel = fos.getChannel();

        //
        ByteBuffer[] bs = utterBS(reps);

        while (gatheringByteChannel.write(bs) > 0) {
            // Empty body
            // Loop until write() return zero
        }

        System.out.println("Mindshare paradigms synergized to " + DEMOGRAPHIC);

        fos.close();
    }

    private static String[] col1 = {
            "Aggregate", "Enable", "Leverage",
            "Facilitate", "Synergize", "Repurpose",
            "Strategize", "Reinvent", "Harness"
    };

    private static String [] col2 = {
            "cross-platform", "best-of-breed", "frictionless",
            "ubiquitous", "extensible", "compelling",
            "mission-critical", "collaborative", "integrated"
    };

    private static String [] col3 = {
            "methodologies", "infomediaries", "platforms",
            "schemas", "mindshare", "paradigms",
            "functionalities", "web services", "infrastructures"
    };

    private static String newLine = System.getProperty("line.separator");

    private static ByteBuffer[] utterBS(int howMany) throws UnsupportedEncodingException {
        List<ByteBuffer> list = new LinkedList<>();
        for (int i = 0; i < howMany; i++) {
            list.add(pickRandom(col1, " "));
            list.add(pickRandom(col2, " "));
            list.add(pickRandom(col2, newLine));
        }

        ByteBuffer[] bufs = new ByteBuffer[list.size()];
        list.toArray(bufs);

        return bufs;
    }

    private static Random rand = new Random();

    private static ByteBuffer pickRandom(String[] strings, String suffix) throws UnsupportedEncodingException {
        String string = strings[rand.nextInt(strings.length)];
        int total = string.length() + suffix.length();
        ByteBuffer buffer = ByteBuffer.allocate(total);

        buffer.put(string.getBytes("US-ASCII"));
        buffer.put(suffix.getBytes("US-ASCII"));
        buffer.flip(); // 转成读模式

        return buffer;
    }
}
