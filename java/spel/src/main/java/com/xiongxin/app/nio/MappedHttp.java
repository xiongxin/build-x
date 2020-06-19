package com.xiongxin.app.nio;

import java.io.*;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

public class MappedHttp {

    private static final String OUTPUT_FILE = "MappedHttp.out";
    private static final String LINE_SEP = "\r\n";
    private static final String SERVER_ID = "Server: Ronsoft Dummy Server";
    private static final String HTTP_HDR =
            "HTTP/1.0 200 OK" + LINE_SEP + SERVER_ID + LINE_SEP;
    private static final String HTTP_404_HDR =
            "HTTP/1.0 404 Not Found" + LINE_SEP + SERVER_ID + LINE_SEP;
    private static final String MSG_404 = "Could not open file: ";

    public static void main(String[] args) throws IOException {
        String file = "/home/xiongxin/Code/build-x/java/spel/blahblah.txt";

        ByteBuffer header = ByteBuffer.wrap(bytes(HTTP_HDR));
        ByteBuffer dynhdrs=  ByteBuffer.allocate(128);
        ByteBuffer[] gather = { header, dynhdrs, null };
        String contentType = "unknown/unknown";
        long contetnLength = -1;

        try {
            FileInputStream fis = new FileInputStream(file);
            FileChannel fc = fis.getChannel();
            MappedByteBuffer filedata = fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());

            gather[2] = filedata;

            contetnLength = fc.size();
            contentType = URLConnection.guessContentTypeFromName(file);

        } catch (IOException e) {
            e.printStackTrace();
        }

        StringBuffer sb = new StringBuffer();
        sb.append("Content-Length: " + contetnLength);
        sb.append(LINE_SEP);
        sb.append("Content-Type: ").append(contentType);
        sb.append(LINE_SEP).append(LINE_SEP);

        dynhdrs.put(bytes(sb.toString()));
        dynhdrs.flip();

        FileOutputStream fos = new FileOutputStream(OUTPUT_FILE);
        FileChannel out = fos.getChannel();

        while (out.write(gather) > 0);

        out.close();

        System.out.println("output written to " + OUTPUT_FILE);
    }


    private static byte[] bytes(String string) throws UnsupportedEncodingException {
        return string.getBytes("US-ASCII");
    }
}
