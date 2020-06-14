package com.xiongxin.app.nio;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;

public class P02 {

    public static void main(String[] args) {
        ByteBuffer bb = ByteBuffer.allocateDirect(8);

        System.out.println("After creation: ");
        printBufferInfo(bb);

        // Must call flip() to reset the position to zero because
        // the printBufferInfo() method use relative get() method,
        // which increments the position
        bb.flip();

        // Populate buffer elements from 50 to 57
        int i = 50;
        while (bb.hasRemaining()) {
            bb.put((byte) i++);
        }

        // Call flip() again to reset the position to zero
        // because the above put() call incremented the position
        bb.flip();

        CharBuffer charBuffer = bb.asCharBuffer();

        System.out.println("Data: ");
        while (charBuffer.hasRemaining()) {
            System.out.print(charBuffer.get() + " ");
        }
        System.out.println();
        bb.flip();
        System.out.println("After populating data");
        printBufferInfo(bb);

        bb.clear();
    }


    public static void printBufferInfo(ByteBuffer bb) {
        int limit = bb.limit();
        System.out.println("Position = " + bb.position() + ", Limit = " + limit);

        // Use absolute reading without affecting the position
        System.out.println("Data: ");
        while (bb.hasRemaining()) {
            System.out.print(bb.get() + " ");
        }
        System.out.println();
    }
}
