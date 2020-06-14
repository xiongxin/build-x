package com.xiongxin.app.io;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class P05 {

    public static void main(String[] args) throws IOException {
        byte[] bytes = new byte[1024];
        for ( int i = 0; i < 100; i++) {
            bytes[i] = (byte) i;
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        baos.write(bytes);
        baos.writeTo(new FileOutputStream("a.txt"));
    }
}
